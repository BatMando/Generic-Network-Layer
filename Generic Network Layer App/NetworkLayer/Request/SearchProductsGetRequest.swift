//
//  SearchProductsGetRequest.swift
//  Generic Network Layer App
//
//  Created by Mohamed Ahmed on 20/09/2023.
//

import Foundation

struct SearchProductsGetRequest: BaseRequestProtocol {
    var searchKey: String
    
    var path: String {
        AppConstants.searchProduct
    }
    
    var method: HTTPMethods {
        .get
    }
    
    var queryParameters: [String : Any]? {
        ["q": searchKey]
    }
    
}
