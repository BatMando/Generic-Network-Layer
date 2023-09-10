//
//  DataError.swift
//  Generic Network Layer App
//
//  Created by Mohamed Ahmed on 09/09/2023.
//

import Foundation

enum DataError: Error {
    case invalidResponse
    case invalidURL
    case invalidData
    case network(Error?)
    case decoding(Error?)
}
