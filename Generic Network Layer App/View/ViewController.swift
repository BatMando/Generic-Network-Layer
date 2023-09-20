//
//  ViewController.swift
//  Generic Network Layer App
//
//  Created by Mohamed Ahmed on 09/09/2023.
//

import UIKit

protocol ViewControllerProtocol {
    // methods for reloding the data, getting data from textfields , etc ..
}
class ViewController: UIViewController {
    lazy var presenter: ViewControllerPresenter! = ViewControllerPresenter(view: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func fetchProducts(_ sender: Any) {
        presenter.getProducts()
    }
    
    
    @IBAction func Add(_ sender: Any) {
        let product = AddProduct(title: "BMW")
        presenter.addProduct(product: product)
        
    }
    
    @IBAction func searchProduct(_ sender: Any) {
        presenter.searchProducts(by: "phone")
    }
    
}

extension ViewController: ViewControllerProtocol {
    // methods implementation
}

