//
//  SignUpViewController.swift
//  Prentis
//
//  Created by Kevin Asistores on 9/30/18.
//  Copyright © 2018 PrentisApp. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.HideKeyboard()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func SignUpButton(_ sender: Any) {
        guard let email = emailField.text else { print("Nope"); return }
        guard let password = passwordField.text else { print("Nope"); return }
//        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
//            // ...
//            if error == nil && user == nil{
//                self.performSegue(withIdentifier: "toHomeFromSignUp", sender: self)
//            }
//            else{
//                print("Could not create user")
//            }
//        }
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            // ...
            if error == nil {
                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                    // ...
                    if error == nil && user != nil {
                        print("You're on!")
                        self.performSegue(withIdentifier: "toHomeFromSignUp", sender: nil)
                    }
                    else{
                        print(error)
                    }
                }
            }
            else{
                print(error)
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
