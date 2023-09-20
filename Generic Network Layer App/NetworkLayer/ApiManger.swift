//
//  ApiManger.swift
//  Generic Network Layer App
//
//  Created by Mohamed Ahmed on 09/09/2023.
//

import Foundation

typealias ResultHandler<T> = (Result<T, APIError>) -> Void

class APIErrorHandler {
    static func handleRequestError(
        _ error: Error?,
        completion: @escaping (APIError) -> Void
    ) {
        if let urlError = error as? URLError {
            let errorCode = urlError.code
            switch errorCode {
            case .notConnectedToInternet, .networkConnectionLost:
                completion(.network(urlError))
            default:
                completion(.network(nil))
            }
        } else {
            completion(.network(nil))
        }
    }
}

class RequestsHandler {
    
    func requestDataAPI(
        url: URLRequest,
        completionHandler: @escaping (Result<Data, APIError>) -> Void
    ) {
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let response = response as? HTTPURLResponse,
                  200 ... 299 ~= response.statusCode else {
                APIErrorHandler.handleRequestError(error) { requestError in
                    completionHandler(.failure(requestError))
                }
                return
            }
            
            guard let data, error == nil else {
                completionHandler(.failure(.invalidData))
                return
            }
            
            completionHandler(.success(data))
        }
        session.resume()
    }
    
}

class ResponseHandler {
    
    func parseResonseDecode<T: Decodable>(
        data: Data,
        modelType: T.Type,
        completionHandler: ResultHandler<T>
    ) {
        do {
            let userResponse = try JSONDecoder().decode(modelType, from: data)
            completionHandler(.success(userResponse))
        }catch {
            completionHandler(.failure(.decoding(error)))
        }
    }
    
}



final class APIManager {
    
    static let shared = APIManager()
    private let requestsHandler: RequestsHandler
    private let responseHandler: ResponseHandler
    
    init(requestsHandler: RequestsHandler = RequestsHandler(),
         responseHandler: ResponseHandler = ResponseHandler()) {
        self.requestsHandler = requestsHandler
        self.responseHandler = responseHandler
    }
    
    func request<T: Codable>(
        modelType: T.Type,
        type: BaseRequestProtocol,
        completion: @escaping ResultHandler<T>
    ) {
        guard var urlComponents = URLComponents(string: type.url.absoluteString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        if let queryParams = type.queryParameters {
            urlComponents.queryItems = queryParams.map { (key, value) in
                URLQueryItem(name: key, value: String(describing: value))
            }
        }
        
        guard let url = urlComponents.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = type.method.rawValue
        
        request.allHTTPHeaderFields = type.headers
        
        if let body = type.body {
            request.httpBody = try? JSONEncoder().encode(body)
        }

        
        print(request)
        requestsHandler.requestDataAPI(url: request) { result in
            switch result {
            case .success(let data):
                self.responseHandler.parseResonseDecode(
                    data: data,
                    modelType: modelType) { response in
                        switch response {
                        case .success(let mainResponse):
                            completion(.success(mainResponse))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }


    static var commonHeaders: [String: String] {
        return [
            "Content-Type": "application/json"
        ]
    }
    
}
