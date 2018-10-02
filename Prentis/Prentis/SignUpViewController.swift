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
import FirebaseFirestore
import FirebaseStorage
import FaceAware

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var chooseImageButton: UIButton!
    var db = Firestore.firestore()
    
    func uploadImageToFirebaseStorage(data: NSData, reference: String){
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let profileRef = storageRef.child(reference)
        
        
        let uploadTask = profileRef.putData(data as Data, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type.
            let size = metadata.size
            // You can also access to download URL after upload.
            profileRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh an error occurred!
                    return
                }
            }
        }

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.HideKeyboard()
        
        if profileImage != nil {
            chooseImageButton.setTitle("", for: UIControlState.normal)
        }

        // Do any additional setup after loading the view.
    }
    
    @IBAction func chooseImage(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Where would you like to get an image from?", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action: UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        profileImage.image = image
        profileImage.contentMode = UIViewContentMode.scaleAspectFill
        profileImage.clipsToBounds = true
        profileImage.focusOnFaces = true
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SignUpButton(_ sender: Any) {
        guard let image = UIImageJPEGRepresentation(profileImage.image!, 0.7) else {return}
        guard let email = emailField.text else { print("Nope"); return }
        guard let password = passwordField.text else { print("Nope"); return }
        guard let username = usernameField.text else { print("Nope"); return }
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            // ...
            if error == nil {
                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                    // ...
                    if error == nil && user != nil {
                        let uid = Auth.auth().currentUser?.uid
                        let path = "ProfileImages/\(uid!).jpg"
                        print("Here's your path motherfucker \(path)")
                        self.uploadImageToFirebaseStorage(data: image as NSData , reference: path)
                        
                        let information = ["bio": "", "uid": Auth.auth().currentUser?.uid as Any, "username": username, "email": email, "interests": [], "expertise": [], "active": true, "profileImage": path]
                        
                        
                        self.db.collection("User").document(Auth.auth().currentUser?.uid ?? username).setData(information) { err in
                            if let err = err {
                                print("Error writing document: \(err)")
                            } else {
                                print("Document successfully written!")
                            }
                        }
                        print(Auth.auth().currentUser?.uid)
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
