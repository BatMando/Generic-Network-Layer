//
//  EndPointType.swift
//  Generic Network Layer App
//
//  Created by Mohamed Ahmed on 09/09/2023.
//

import Foundation

enum HTTPMethods: String {
    case get = "GET"
    case post = "POST"
}

protocol BaseRequestProtocol {
    var path: String { get }
    var baseURL: String { get }
    var url: URL { get }
    var method: HTTPMethods { get }
    var queryParameters: [String: Any]? { get }
    var body: Encodable? { get }
    var headers: [String: String]? { get }
}

extension BaseRequestProtocol {
    var baseURL: String {
        return AppConstants.baseURL
    }
    var url: URL {
        return URL(string: "\(baseURL)\(path)")!
    }
    var queryParameters: [String : Any]? {
        return nil
    }
    var body: Encodable? {
        return nil
    }
    var headers: [String : String]? {
        commonHeaders
    }
}

