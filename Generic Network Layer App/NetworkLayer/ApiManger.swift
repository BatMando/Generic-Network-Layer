//
//  ApiManger.swift
//  Generic Network Layer App
//
//  Created by Mohamed Ahmed on 09/09/2023.
//

import Foundation

typealias ResultHandler<T> = (Result<T, DataError>) -> Void

class RequestsHandler {

    func requestDataAPI(
        url: URLRequest,
        completionHandler: @escaping (Result<Data, DataError>) -> Void
    ) {
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let response = response as? HTTPURLResponse,
                  200 ... 299 ~= response.statusCode else {
                completionHandler(.failure(.invalidResponse))
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
        type: EndPointType,
        completion: @escaping ResultHandler<T>
    ) {
        guard let url = type.url else {
            completion(.failure(.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = type.method.rawValue

        if let parameters = type.body {
            request.httpBody = try? JSONEncoder().encode(parameters)
        }

        request.allHTTPHeaderFields = type.headers

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
