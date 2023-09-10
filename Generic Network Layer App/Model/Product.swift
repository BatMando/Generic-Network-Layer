//
//  Product.swift
//  Generic Network Layer App
//
//  Created by Mohamed Ahmed on 09/09/2023.
//

import Foundation

struct ProductsResponse: Codable {
    let products: [Product]
}

// MARK: - Product
struct Product: Codable {
    let id: Int
    let title, description: String
    let price: Int
    let discountPercentage, rating: Double
    let stock: Int
    let brand, category: String
    let thumbnail: String
    let images: [String]
}
