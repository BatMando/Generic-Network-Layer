//
//  AddProductPostRequest.swift
//  Generic Network Layer App
//
//  Created by Mohamed Ahmed on 20/09/2023.
//

import Foundation

struct AddProductPostRequest: BaseRequestProtocol {
   
    var product: AddProduct
    
    var path: String {
        "products/add"
    }
    
    var method: HTTPMethods {
        .post
    }
    var body: Encodable? {
        product
    }

}
