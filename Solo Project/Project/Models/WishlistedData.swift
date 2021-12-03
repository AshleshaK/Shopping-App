//
//  WishlistedData.swift
//  Project
//
//  Created by Mac on 22/11/21.
//

import Foundation
import SQLite3


class ProductsDatabase{
    var db: OpaquePointer?
    
    init() {
       db = createAndOpen()
    }
    
//MARK: Create and Open Database
    
    private func createAndOpen() ->OpaquePointer? {
        let dataBaseName = "Products.sqlite"
        var db : OpaquePointer?
        
        do {
            let documentDir = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(dataBaseName)
            if sqlite3_open(documentDir.path, &db) == SQLITE_OK{
                print("Database opened successfully..")
                print("Database path \(documentDir.path)")
                return db
            }
            else
            {
                print("Unable to open Database")
            }
        }
        
        catch
        {
            print("Unable to get document Directory \(error.localizedDescription)")
        }
        return nil
    }
    
    
//MARK: Create Table Function
    
    func createProductsTable(){
        var createTableStatement: OpaquePointer?
        let createTableQuery = "CREATE TABLE IF NOT EXISTS products(id INTGER PRIMARY KEY,title TEXT,price INTGER, description TEXT,category TEXT,image TEXT,rating INTGER)"
        
        if sqlite3_prepare_v2(db, createTableQuery, -1, &createTableStatement, nil) == SQLITE_OK{
            if sqlite3_step(createTableStatement) == SQLITE_DONE{
                print("Products table successfully created..")
            }
            else
            {
                print("Unable to create Products Table!!!")
            }
        }
        else
        {
            print("Unable to prepare create table statement!!")
        }
    }
    
   
//MARK: Insert Values Function
    
    func insertValuesInProducts(product:ProductDetails){
        var insertStatement: OpaquePointer?
        let insertQuery = "INSERT INTO products(id,title,price,description,category,image,rating) VALUES(?,?,?,?,?,?,?)"
        if sqlite3_prepare_v2(db, insertQuery, -1, &insertStatement, nil) == SQLITE_OK{
            let idInt32 = Int32(product.id)
            sqlite3_bind_int(insertStatement, 1, idInt32)
            
            let titleNS = product.title as NSString
            let titleText = titleNS.utf8String
            sqlite3_bind_text(insertStatement, 2, titleText, -1, nil)
            
            let priceInt32 = Int32(product.price)
            sqlite3_bind_int(insertStatement, 3, priceInt32)
            
            let descriptionText = (product.description as NSString).utf8String
            sqlite3_bind_text(insertStatement, 4, descriptionText, -1, nil)
            
            let categoryText = (product.category as NSString).utf8String
            sqlite3_bind_text(insertStatement, 5, categoryText, -1, nil)
            let imageText = (product.image as NSString).utf8String
            sqlite3_bind_text(insertStatement, 6, imageText, -1, nil)
            
           if sqlite3_step(insertStatement) == SQLITE_DONE{
                print("Values inserted successfully in Products table..")
            }
            else
            {
                print("Unable to insert values in table!!!")
            }
        }
        else
        {
            print("Unable to prepare insert Query!!!")
        }
        sqlite3_finalize(insertStatement)
    }
    
//MARK: Delete Item Function

    func deleteByID(id:Int) {
            let deleteStatementStirng = "DELETE FROM products WHERE id = ?;"
            var deleteStatement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
                sqlite3_bind_int(deleteStatement, 1, Int32(id))
                if sqlite3_step(deleteStatement) == SQLITE_DONE {
                    print("Successfully deleted row.")
                } else {
                    print("Could not delete row.")
                }
            } else {
                print("DELETE statement could not be prepared")
            }
            sqlite3_finalize(deleteStatement)
        }
        
//MARK: Display Products Function
    
    func displayProducts()-> [ProductDetails]?{
        var selectStatement: OpaquePointer?
        let selectQuery = "SELECT * FROM products"
        var products = [ProductDetails]()
        
        if sqlite3_prepare_v2(db,selectQuery, -1, &selectStatement, nil) == SQLITE_OK{
            while sqlite3_step(selectStatement) == SQLITE_ROW {
                
                let id = Int(sqlite3_column_int(selectStatement, 0))
                guard let title_CStr = sqlite3_column_text(selectStatement, 1) else{
                    print("Error while getting name from db!!!")
                    continue
                }
                let title = String(cString: title_CStr)
                let price = Int(sqlite3_column_int(selectStatement, 2))
                
                guard let decsription_CStr = sqlite3_column_text(selectStatement, 3) else {
                    print("Error while getting username from db!!!")
                    continue
                }
                let description = String(cString: decsription_CStr)
                
                guard let category_CStr = sqlite3_column_text(selectStatement, 4) else {
                    print("Error while getting email from db!!!")
                    continue
                }
                let category = String(cString: category_CStr)
                
                guard let image_CStr = sqlite3_column_text(selectStatement, 5) else {
                    print("Error while getting address from db!!!")
                    continue
                }
                let image = String(cString: image_CStr)
                
                let product = ProductDetails(id: id, title: title, price: Double(price), description: description, category: category, image: image)
                products.append(product)
             
            }
            return products
        }
        else
        {
            print("Unable to prepare select query!!!")
        }
        sqlite3_finalize(selectStatement)
        return nil
    }
    
}
