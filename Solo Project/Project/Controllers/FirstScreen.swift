//
//  FirstScreen.swift
//  Project
//
//  Created by Mac on 21/11/21.
//

import UIKit

class FirstScreen: UIViewController {

    @IBOutlet weak var collectionview: UICollectionView!
    
    var categoryArray = ["Men's Clothing","Women's Clothing","Jewellary","Electronics"]
    var productsArray = [ProductDetails]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        collectionview.dataSource = self
        collectionview.delegate = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Login", style: .done, target: self, action: #selector(tapToLogin))
        navigationItem.rightBarButtonItem?.tintColor = .purple
       
    }
    
//MARK: View All Products Button Action
    
    @IBAction func tapToViewProducts(_ sender: Any) {
        if let allProductsVc = storyboard?.instantiateViewController(withIdentifier: "AllProducts") as? AllProducts {
            self.navigationController?.pushViewController(allProductsVc, animated: true)
        }
    }
    
//MARK: Function TapToLogin
    
    @objc func tapToLogin () {
        if let loginVc = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            self.navigationController?.pushViewController(loginVc, animated: true)
        }
    }
}

//MARK: UICollectionViewDataSource

extension FirstScreen: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categoryArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ArrayCollectionViewCell {
            cell.avatarImg.image = UIImage(named: categoryArray[indexPath.item])
            cell.categoryLabel.text = categoryArray[indexPath.item]
            return cell
        }
        return UICollectionViewCell()
    }
}

//MARK: UICollectionViewDelegateFlowLayout

extension FirstScreen: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width, height: 500.0)
        
    }
}
