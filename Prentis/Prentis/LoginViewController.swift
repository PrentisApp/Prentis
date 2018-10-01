//
//  LoginViewController.swift
//  Prentis
//
//  Created by Kevin Asistores on 9/30/18.
//  Copyright © 2018 PrentisApp. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

extension UIViewController{
    func HideKeyboard() {
        let Tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        view.addGestureRecognizer(Tap)
    }
    
    @objc func DismissKeyboard() {
        view.endEditing(true)
    }
}


class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.HideKeyboard()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "toHomeFromLogin", sender: nil)
        }
    }
    
    @IBAction func loginButton(_ sender: Any) {
        
        guard let email = emailField.text else { print("Nope"); return }
        guard let password = passwordField.text else { print("Nope"); return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            // ...
            if let u = user {
                // If the user is found, then login
                self.performSegue(withIdentifier: "toHomeFromLogin", sender: nil)
            }
            else{
                // Show Error Message
                print("User is not found")
            }
        }
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
