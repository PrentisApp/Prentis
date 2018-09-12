//
//  LoginViewController.swift
//  Prentis
//
//  Created by Kevin Asistores on 9/11/18.
//  Copyright © 2018 PrentisApp. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

extension UIViewController {
    func HideKeyboard(){
        let Tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        
        view.addGestureRecognizer(Tap)
    }
    
    @objc func DismissKeyboard() {
        view.endEditing(true)
    }
    
}

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var longButton: UIButton!
    @IBOutlet weak var loginSegment: UISegmentedControl!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    var isLogin:Bool = true
    
    @IBAction func loginControl(_ sender: Any) {
        isLogin = !isLogin
        
        if isLogin{
            longButton.setTitle("Login" , for: .normal)
        }
        else {
            longButton.setTitle("Sign up" , for: .normal)
        }

    }
    
    @IBAction func LoginAction(_ sender: Any) {
        guard let email = emailField.text else { print("Nope"); return }
        guard let password = passwordField.text else { print("Nope"); return }
        
        
            if isLogin{
                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                    // ...
                    if let u = user {
                        // If the user is found, then login
                        print("You've logged in!")
                    }
                    else{
                        // Show Error Message
                        print("User is not found")
                    }
                }
            }
            else{
                Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                    // ...
                   
                    if error == nil && user != nil{
                        print("User created")
                    }
                    else{
                        print("Could not create user")
                    }
                    
                }
                

                
            }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.HideKeyboard()
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
