//
//  DataError.swift
//  Generic Network Layer App
//
//  Created by Mohamed Ahmed on 09/09/2023.
//

import Foundation

enum APIError: Error {
    case invalidResponse
    case invalidURL
    case invalidData
    case decoding(Error?)
    case network(Error?) // Network-related error
    case unauthorized(message: String) // HTTP 401
    case forbidden(message: String) // HTTP 403
    case notFound(message: String) // HTTP 404
        
    var localizedDescription: String {
        switch self {
        case .invalidResponse:
            return "Invalid Response"
        case .invalidURL:
            return "Invalid URL"
        case .invalidData:
            return "Invalid Data"
        case .decoding(let error):
            return "Decoding Error: \(error?.localizedDescription ?? "Unknown")"
        case .network(let error):
            return "Network Error: \(error?.localizedDescription ?? "Unknown")"
        case .unauthorized(let message):
            return message
        case .forbidden(let message):
            return message
        case .notFound(let message):
            return message
        }
    }
}
