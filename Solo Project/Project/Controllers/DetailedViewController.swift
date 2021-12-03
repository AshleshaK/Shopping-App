//
//  DetailedViewController.swift
//  Project
//
//  Created by Mac on 22/11/21.
//

import UIKit

//MARK: DetailedScreenViewControllerProtocol

protocol DetailedScreenViewControllerProtocol: AnyObject {
    func wishlistedItem(item: Int?)
}

class DetailedViewController: UIViewController {
    var detailsOfProduct: ProductDetails?
    var item: Int?
    weak var delegate: DetailedScreenViewControllerProtocol?
    
    @IBOutlet weak var detaliedImage: UIImageView!
    @IBOutlet weak var detailedTitle: UILabel!
    @IBOutlet weak var detailePrice: UILabel!
    @IBOutlet weak var detailedCategory: UILabel!
    @IBOutlet weak var detailedDescription: UITextView!
    @IBOutlet weak var detailedRating: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Wishlist", style: .done, target: self, action: #selector(tapToWishlist))
        
        let link = detailsOfProduct?.image
        detaliedImage.downloaded(from: link!)
        detailedTitle.text = "Title:\(detailsOfProduct?.title ?? "")"
        detailePrice.text = "Price: Rs.\(String(detailsOfProduct?.price ?? 0))"
        detailedCategory.text = "Category:\(detailsOfProduct?.category ?? "")"
        detailedDescription.text = "Description:\(detailsOfProduct?.description ?? "")"
                

    }
    
//MARK: Function tapToWishlist
    
    @objc func tapToWishlist() {
        let dbHelper = ProductsDatabase()
        dbHelper.createProductsTable()
        guard let product = detailsOfProduct else {
            return
    }
        dbHelper.insertValuesInProducts(product: product)
        delegate?.wishlistedItem(item: item)
       
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func deleteBtn(){
        guard  let product = detailsOfProduct else {
            return
        }
        let dbHelper = ProductsDatabase()
        dbHelper.deleteByID(id: product.id)
        DispatchQueue.main.async {
            self.back()
        }
        
    }
    func back()  {
        self.navigationController?.popViewController(animated: true)
    }

        
    }
   

    

    

