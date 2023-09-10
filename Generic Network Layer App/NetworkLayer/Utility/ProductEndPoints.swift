//
//  ProductEndPoints.swift
//  Generic Network Layer App
//
//  Created by Mohamed Ahmed on 09/09/2023.
//

import Foundation

enum ProductEndPoints {
    case products
    case addProduct(product: AddProduct)
}

extension ProductEndPoints: EndPointType {

    var path: String {
        switch self {
        case .products:
            return "products"
        case .addProduct:
            return "products/add"
        }
    }

    var baseURL: String {
        return "https://dummyjson.com/"
    }

    var url: URL? {
        return URL(string: "\(baseURL)\(path)")
    }

    var method: HTTPMethods {
        switch self {
        case .products:
            return .get
        case .addProduct:
            return .post
        }
    }

    var body: Encodable? {
        switch self {
        case .products:
            return nil
        case .addProduct(let product):
            return product
        }
    }

    var headers: [String : String]? {
        APIManager.commonHeaders
    }
}
