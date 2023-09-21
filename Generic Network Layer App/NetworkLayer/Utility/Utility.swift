//
//  Utility.swift
//  Generic Network Layer App
//
//  Created by Mohamed Ahmed on 20/09/2023.
//

import Foundation

typealias ResultHandler<T> = (Result<T, APIError>) -> Void

struct ApiConstants {
    static let productsEndPoint: String = "products"
    static let addProductEndPoint: String = "products/add"
    static let searchProductEndPoint: String = "products/search"
    static let baseURL: String = "https://dummyjson.com/"
}

var commonHeaders: [String: String] {
    return [
        "Content-Type": "application/json"
    ]
}



