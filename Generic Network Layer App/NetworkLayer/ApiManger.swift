//
//  ApiManger.swift
//  Generic Network Layer App
//
//  Created by Mohamed Ahmed on 09/09/2023.
//

import Foundation


typealias ResultHandler<T> = (Result<T, APIError>) -> Void

protocol APIErrorHandlerProtocol {
    func handleRequestError(_ error: Error?,completion: @escaping (APIError) -> Void)
}

class APIErrorHandler: APIErrorHandlerProtocol {
    func handleRequestError(
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


protocol RequestsHandlerProtocol {
    func requestDataAPI(url: URLRequest, apiErrorHandler: APIErrorHandlerProtocol , completionHandler: @escaping (Result<Data, APIError>) -> Void)
}

class RequestsHandler: RequestsHandlerProtocol {
    
    func requestDataAPI(
        url: URLRequest,
        apiErrorHandler: APIErrorHandlerProtocol,
        completionHandler: @escaping (Result<Data, APIError>) -> Void
    ) {
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let response = response as? HTTPURLResponse,
                  200 ... 299 ~= response.statusCode else {
                apiErrorHandler.handleRequestError(error) { requestError in
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
protocol ResponseHandlerProtocol {
    func parseResonseDecode<T: Decodable>(data: Data,modelType: T.Type,completionHandler: ResultHandler<T>)
}
class ResponseHandler: ResponseHandlerProtocol {
    
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

protocol APIManagerProtocl {
    func request<T: Codable>(
        modelType: T.Type,
        requestType: BaseRequestProtocol,
        completion: @escaping ResultHandler<T>
    )
}
final class APIManager: APIManagerProtocl {
    
    static let shared = APIManager()
    private let requestsHandler: RequestsHandlerProtocol
    private let responseHandler: ResponseHandlerProtocol
    private let apiErrorHandler: APIErrorHandlerProtocol
    
    init(requestsHandler: RequestsHandlerProtocol = RequestsHandler(),
         responseHandler: ResponseHandlerProtocol = ResponseHandler(),
         apiErrorHandler: APIErrorHandlerProtocol = APIErrorHandler()
    ) {
        self.requestsHandler = requestsHandler
        self.responseHandler = responseHandler
        self.apiErrorHandler = apiErrorHandler
    }
    
    func request<T: Codable>(
        modelType: T.Type,
        requestType: BaseRequestProtocol,
        completion: @escaping ResultHandler<T>
    ) {
        guard var urlComponents = URLComponents(string: requestType.url.absoluteString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        if let queryParams = requestType.queryParameters {
            urlComponents.queryItems = queryParams.map { (key, value) in
                URLQueryItem(name: key, value: String(describing: value))
            }
        }
        
        guard let url = urlComponents.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = requestType.method.rawValue
        
        request.allHTTPHeaderFields = requestType.headers
        
        if let body = requestType.body {
            request.httpBody = try? JSONEncoder().encode(body)
        }

        
        print(request)
        requestsHandler.requestDataAPI(url: request, apiErrorHandler: apiErrorHandler) { result in
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
