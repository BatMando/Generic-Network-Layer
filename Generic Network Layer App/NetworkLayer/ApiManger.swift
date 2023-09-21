//
//  ApiManger.swift
//  Generic Network Layer App
//
//  Created by Mohamed Ahmed on 09/09/2023.
//

import Foundation

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
}
