//
//  ViewControllerPresenter.swift
//  Generic Network Layer App
//
//  Created by Mohamed Ahmed on 20/09/2023.
//

import Foundation
protocol ViewControllerPresenterProtocol {
    var apiManager: APIManagerProtocl { get set }
    func getProducts()
    func searchProducts(by name: String)
    func addProduct(product: AddProduct)
}

class ViewControllerPresenter: ViewControllerPresenterProtocol {
    
    var apiManager: APIManagerProtocl
    weak var view: ViewControllerProtocol?
    
    init(apiManager: APIManagerProtocl = APIManager.shared, view: ViewControllerProtocol) {
        self.apiManager = apiManager
        self.view = view
    }
    
    func getProducts() {
        apiManager.request(
            modelType: ProductsResponse.self,
            requestType: ProductsGetRequest()) { response in
            switch response {
            case .success(let productsResponse):
                print(productsResponse)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func searchProducts(by name: String) {
        apiManager.request(
            modelType: ProductsResponse.self,
            requestType: SearchProductsGetRequest(searchKey: name)) { response in
            switch response {
            case .success(let productsResponse):
                print(productsResponse)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func addProduct(product: AddProduct) {
        apiManager.request(
            modelType: AddProduct.self,
            requestType: AddProductPostRequest(product: product)) { result in
                switch result {
                case .success(let product):
                    print(product)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
