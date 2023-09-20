//
//  ResponseHandler.swift
//  Generic Network Layer App
//
//  Created by Mohamed Ahmed on 20/09/2023.
//

import Foundation


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

