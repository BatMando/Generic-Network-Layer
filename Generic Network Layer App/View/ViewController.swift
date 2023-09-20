//
//  ViewController.swift
//  Generic Network Layer App
//
//  Created by Mohamed Ahmed on 09/09/2023.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func fetchProducts(_ sender: Any) {
        APIManager.shared.request(modelType: ProductsResponse.self, type: ProductsGetRequest()) { response in
            switch response {
            case .success(let productsResponse):
                print(productsResponse)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    @IBAction func Add(_ sender: Any) {
        let product = AddProduct(title: "BMW")
    
        APIManager.shared.request(
            modelType: AddProduct.self,
            type: AddProductPostRequest(product: product)) { result in
                switch result {
                case .success(let product):
                    print(product)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
    
    @IBAction func searchProduct(_ sender: Any) {
        APIManager.shared.request(modelType: ProductsResponse.self, type: SearchProductsGetRequest(searchKey: "phone")) { response in
            switch response {
            case .success(let productsResponse):
                print(productsResponse)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

