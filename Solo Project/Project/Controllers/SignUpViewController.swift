//
//  SignUpViewController.swift
//  Project
//
//  Created by Mac on 13/11/21.
//

import UIKit

class SignUpViewController: UITableViewController {
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    var activeTextFieldForSignup: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profilePic.addGestureRecognizer(tapGesture)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "LogIn", style: .done, target: self, action: #selector(tapToLogin))
        navigationItem.rightBarButtonItem?.tintColor = .purple
    
        
        
        let center: NotificationCenter = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        center.addObserver(self, selector: #selector(keyboardHidden(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        
    }
    
//MARK: Function Image Tapped

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        openGallery()
        
    }

//MARK: Show Keyboard Function

    @objc func keyboardShown(notification:Notification) {
        
        let info: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardsize = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardY = self.view.frame.height - keyboardsize.height
        let editingTextFieldY = activeTextFieldForSignup.convert(activeTextFieldForSignup.bounds, to: self.view).minY
        
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

//MARK: Login Button Method

    @objc func tapToLogin(){
        navigationController?.popViewController(animated: true)
    }
    
//MARK: Tap To Signup Button Action
    
    @IBAction func tapToSignUp(_ sender: Any) {
        checkConditions()
    }
    
//MARK: Tap To Skip Button Action

    @IBAction func tapToSkip(_ sender: UIButton) {
        if let allProductsObj = storyboard?.instantiateViewController(withIdentifier: "AllProducts") as? AllProducts {
            self.navigationController?.pushViewController(allProductsObj, animated: true)
        }
        
    }
 
//MARK: Function Check Conditions

    fileprivate func checkConditions(){
        
        let imageSystem = UIImage(systemName: "person.circle.fill")
        if profilePic.image?.pngData() != imageSystem?.pngData() {
            if let username = usernameTextField.text, let password = passwordTextField.text, let email = emailTextField.text, let confirmPassword = confirmPasswordTextField.text {
                
                if !username.validateUsername() {
                        openAlert(title: "Alert", message: "Invalid Username", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                            print("Okay clicked!")
                        }])
                }
                else if username == "" {
                        openAlert(title: "Alert", message: "Please enter Username", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                            print("Okay clicked!")
                        }])
                }
                else if email.validateEmail(){
                        openAlert(title: "Alert", message: "Email not found!", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                            print("Okay clicked!")
                        }])
                }
                else if email == "" {
                        openAlert(title: "Alert", message: "Please enter Email.", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
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
                else if password != confirmPassword{
                    openAlert(title: "Alert", message: "Password is not matching!", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                        print("Okay clicked!")
                    }])
                }
                else if confirmPassword == "" {
                    openAlert(title: "Alert", message: "Please confirm your Password.", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
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
        else {
            openAlert(title: "Alert", message: "Please set your Profile Picture.", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                 print("Okay clicked!")
             }])
            print("same")
        }
    }
    
}
//
//MARK: Content Height Manager
//

extension SignUpViewController {
    
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

extension SignUpViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextFieldForSignup = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

//MARK: Function tapToWishlist

extension SignUpViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .savedPhotosAlbum
            present(picker, animated: true)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[.originalImage] as? UIImage {
            profilePic.image = img
        }
        dismiss(animated: true)
    }
}




