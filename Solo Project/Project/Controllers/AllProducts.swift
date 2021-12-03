//
//  AllProducts.swift
//  Project
//
//  Created by Mac on 22/11/21.
//

import UIKit

class AllProducts: UIViewController {
    
    
    @IBOutlet weak var collectionview: UICollectionView!
    
    var productsArray = [ProductDetails]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionview.dataSource = self
        collectionview.delegate = self
        
        let image = UIImage.init(systemName: "suit.heart")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: image , style: .done, target: self, action: #selector(tapToSeeWishlist))
        
        navigationItem.rightBarButtonItem?.tintColor = .purple
        apiParse()

    
    }

//MARK: Function TapToSeeWishlist
    
    @objc func tapToSeeWishlist() {
      let dbHelper = ProductsDatabase()
        guard let productsDB = dbHelper.displayProducts()
          else {
            print("nil data obtained from db!!!")
            return
        }
        if let wishlistObj = storyboard?.instantiateViewController(withIdentifier: "YourWishlist") as? YourWishlist {
            wishlistObj.products = productsDB
            self.navigationController?.pushViewController(wishlistObj, animated: true)
        }
        
    }
    
//MARK: API Parsing

    func apiParse() {
        let url = URL(string: "https://fakestoreapi.com/products")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            do{
                if error == nil
                {
                self.productsArray = try JSONDecoder().decode([ProductDetails].self, from: data!)
                
                for product in self.productsArray{
                    DispatchQueue.main.async {
                         self.collectionview.reloadData()
                    }
                   }
                }
            
            }
            catch
            {
                print("Error in get json data")
            }
            
        }.resume()
}
}

//MARK: UICollectionViewDataSource Method

extension AllProducts: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        productsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let productCells = productsArray[indexPath.item]
        if let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "productcell", for: indexPath) as? AllProductsCollection {
            
            cell.productTitle.text = productCells.title
            cell.productPrice.text = ("Rs.\(String(productCells.price))")
            let link = productsArray[indexPath.item].image
            cell.productImage.downloaded(from: link)
            return cell
        }
        return UICollectionViewCell()
    }
    
    
}

//MARK: UICollectionViewDelegateFlowLayout Method

extension AllProducts: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width, height: 510.0)
    }
}

//MARK: UICollectionViewDelegate Method

extension AllProducts: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let details = productsArray[indexPath.item]
        if let detailsVc = storyboard?.instantiateViewController(identifier: "DetailedViewController") as? DetailedViewController {
           
            detailsVc.detailsOfProduct = details
            self.navigationController?.pushViewController(detailsVc, animated: true)
            
        }
    }
}

