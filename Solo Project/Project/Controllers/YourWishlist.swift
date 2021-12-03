//
//  YourWishlist.swift
//  Project
//
//  Created by Mac on 22/11/21.
//

import UIKit

class YourWishlist: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var products = [ProductDetails]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self

    }
   
}

//MARK: UICollectionViewDataSource Method

extension YourWishlist: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let wishlistedProduct = products[indexPath.item]
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "wishlist", for: indexPath) as? WishlistCollection {
            
            let link = products[indexPath.item].image
            cell.wishlistImg.downloaded(from: link)
            cell.wishlistedTitle.text = "Title: \(wishlistedProduct.title )"
            cell.wishlistedPrice.text = "Price: Rs.\(String(wishlistedProduct.price))"
            return cell
        }
        return UICollectionViewCell()
    }
    
}

//MARK: UICollectionViewDelegate Method

extension YourWishlist: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = products[indexPath.item]
        if let detaliedScreenObj = storyboard?.instantiateViewController(identifier: "DetailedViewController") as? DetailedViewController {
            detaliedScreenObj.detailsOfProduct = product
            detaliedScreenObj.item = indexPath.item
            self.navigationController?.pushViewController(detaliedScreenObj, animated: true)
        }
    }
}

//MARK: UICollectionViewDelegateFlowLayout Method

extension YourWishlist: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width, height: 500.0)
    }
}

