//
//  HomePageViewController.swift
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

class HomePageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var userTable: UITableView!
    
    var docRef: DocumentReference!
    var db = Firestore.firestore()
    var documents = [] as [[String: Any]]
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let docRef = db.collection("User").document((Auth.auth().currentUser?.uid)!)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let defaults = UserDefaults.standard
                defaults.set(document["interests"] as! [String], forKey: "interestsArray")
                defaults.set(document["expertise"] as! [String], forKey: "expertiseArray")
                
            } else {
                print("Document does not exist")
            }
        }
        
        db.collection("User").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Hey you got an error querying all the users \(error)")
            } else {
                for document in querySnapshot!.documents {
                    self.documents.append(document.data() as [String: Any])
                }
                self.userTable.reloadData()
            }
        }
        
        userTable.dataSource = self
        userTable.delegate = self
        
    }
    
    func numberOfSections(in userTable: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ userTable: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.documents.count
    }
    
    func tableView(_ userTable: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = userTable.dequeueReusableCell(withIdentifier: "UserTableViewCell") as! UserCell
        let document = self.documents[indexPath.row]
        cell.mentor = Mentor(mentorDoc: document)
        
        return cell
    }
    
    @IBAction func signOutButton(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
        do {
            try! Auth.auth().signOut()
        }
        catch let logoutError {
            print(logoutError)
        }
        
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let signInPage = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        self.present(signInPage, animated: true, completion: nil)
    }
    
    
    @IBAction func toUser(_ sender: Any) {
        let yourArticleViewController = UIStoryboard(name: "UserProfile", bundle: nil).instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
        self.navigationController?.pushViewController(yourArticleViewController, animated: true)
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
