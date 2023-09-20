//
//  Utility.swift
//  Generic Network Layer App
//
//  Created by Mohamed Ahmed on 20/09/2023.
//

import Foundation

typealias ResultHandler<T> = (Result<T, APIError>) -> Void

struct AppConstants {
    static let products: String = "products"
    static let addProduct: String = "products/add"
    static let searchProduct: String = "products/search"
    static let baseURL: String = "https://dummyjson.com/"

}

var commonHeaders: [String: String] {
    return [
        "Content-Type": "application/json"
    ]
}



