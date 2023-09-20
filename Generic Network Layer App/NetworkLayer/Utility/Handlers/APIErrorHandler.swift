//
//  APIErrorHandler.swift
//  Generic Network Layer App
//
//  Created by Mohamed Ahmed on 20/09/2023.
//

import Foundation


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

