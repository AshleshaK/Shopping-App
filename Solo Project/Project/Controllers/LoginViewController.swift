//
//  LoginViewController.swift
//  Project
//
//  Created by Mac on 13/11/21.
//

import UIKit
import FacebookCore
import FacebookLogin

class LoginViewController: UITableViewController {

    @IBOutlet weak var facebookLogin: FBLoginButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var activeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        usernameTextField.delegate = self
        passwordTextField.delegate = self
      
        if let token = AccessToken.current,
               !token.isExpired {
            if let wishlistScreenObj = storyboard?.instantiateViewController(identifier: "YourWishlist") as? YourWishlist {
            self.navigationController?.pushViewController(wishlistScreenObj, animated: true)
            }
        }
        
        facebookLogin.permissions = ["name", "email"]
        facebookLogin.delegate = self
      
        let center: NotificationCenter = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        center.addObserver(self, selector: #selector(keyboardHidden(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        
    }
    
//MARK: Show Keyboard Function

    @objc func keyboardShown(notification:Notification) {
        
        guard let textfield = activeTextField else {return}
        let info: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardsize = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardY = self.view.frame.height - keyboardsize.height
        let editingTextFieldY = textfield.convert(activeTextField.bounds, to: self.view).minY
        
        if self.view.frame.minY >= 0 {
            
        if editingTextFieldY>keyboardY-80 {
                UIView.animate(withDuration: 0.25,
                               delay: 0.0,
                               options: UIView.AnimationOptions.curveEaseIn) {
                self.view.frame = CGRect(x: 0,
                                         y:self.view.frame.origin.y-(editingTextFieldY-(keyboardY-50)),
                                         width: self.view.bounds.width,
                                         height: self.view.bounds.height)
                }
            }
        }
        
    }
    
//MARK: Hide Keyboard Function

    @objc func keyboardHidden(notification:Notification){
        UIView.animate(withDuration: 0.25,
                       delay: 0.0,
                       options: UIView.AnimationOptions.curveEaseIn) {
        self.view.frame = CGRect(x: 0,
                                 y: 0,
                                 width: self.view.bounds.width,
                                 height: self.view.bounds.height)
        }
        
    }
 
//MARK: Login Button Action
    
    @IBAction func tapToLogin(_ sender: UIButton) {
        checkConditions()
        
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

//MARK: Function Check Conditions
    
    fileprivate func checkConditions(){
        if let username = usernameTextField.text, let password = passwordTextField.text {
        if !username.validateUsername(){
                openAlert(title: "Alert", message: "Invalid Username", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                    print("Okay clicked!")
                }])
        }
        else if username == "" {
                openAlert(title: "Alert", message: "Please enter Username.", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                    print("Okay clicked!")
                }])
        }
        else if !password.validatePassword(){
                openAlert(title: "Alert", message: "Please enter valid Password!", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                    print("Okay clicked!")
                }])
        }
        else if password == "" {
                openAlert(title: "Alert", message: "Please enter Password.", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                    print("Okay clicked!")
                }])
        }
        else {
            
            return
        }
            
        }
        else {
            openAlert(title: "Alert", message: "Please enter valid data.", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                print("Okay clicked!")
            }])
            
        }
    }

//MARK: Sign Up Button Action
    
    @IBAction func tapToSignUp(_ sender: Any) {
              navigateToSignUp()
    }

//MARK: Function NavigateToSignUp
    
    fileprivate func navigateToSignUp() {
        if let signupObj = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
            self.navigationController?.pushViewController(signupObj, animated: true)
        }
    }
}


//MARK: Content Height Manager

extension LoginViewController {
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let tableViewHeight = self.tableView.frame.height
        let contentHeight = self.tableView.contentSize.height
        
        let centeringInset = (tableViewHeight - contentHeight) / 2.0
        let topInset = max(centeringInset, 0.0)
        
        self.tableView.contentInset = UIEdgeInsets(top: topInset, left: 0.0, bottom: 0.0, right: 0.0)
    }
}

//MARK: UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

//MARK: LoginButtonDelegate

extension LoginViewController: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        let token = result?.token?.tokenString
        let request = FacebookLogin.GraphRequest(graphPath: "me", parameters: ["field":"email, name"], tokenString: token, version: nil, httpMethod: .get)
        request.start { (connection, request, error) in
            print("\(String(describing: result))")
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("Logout")
    }
    
    
}
