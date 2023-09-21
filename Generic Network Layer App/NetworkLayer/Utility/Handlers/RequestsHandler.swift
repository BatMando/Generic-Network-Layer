//
//  RequestsHandler.swift
//  Generic Network Layer App
//
//  Created by Mohamed Ahmed on 20/09/2023.
//

import Foundation

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
