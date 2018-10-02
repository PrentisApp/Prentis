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

class HomePageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var userTable: UITableView!
    
    var docRef: DocumentReference!
    var db = Firestore.firestore()
    var documents = [] as [[String: Any]]
    
    func numberOfSections(in userTable: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ userTable: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.documents.count
    }
    
    func tableView(_ userTable: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = userTable.dequeueReusableCell(withIdentifier: "UserTableViewCell") as! UserCell
        let document = self.documents[indexPath.row]
        cell.usernameLabel.text = (document["username"] as! String)
        cell.bioLabel.text = (document["bio"] as! String)
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        db.collection("User").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Hey you got an error querying all the users \(error)")
            } else {
                //self.documents = []
                for document in querySnapshot!.documents {
                    self.documents.append(document.data() as [String: Any])
                    //print("document name is \(document.data()["username"])")
                    //print("document uid is \(document.data()["uid"])")
                }
                self.userTable.reloadData()
            }
        }
        
        
        userTable.dataSource = self
        userTable.delegate = self
        
        
        
        //userTest.text = Auth.auth().currentUser?.email
        docRef = Firestore.firestore().document("User/NewDoc")
//        var username = ["username": "MYYYY EYEEES", "uid": "hsdfisdf"]
//        docRef.setData(username)
//
//        docRef.getDocument { (DocumentSnapshot, Error) in
//            let myData = DocumentSnapshot?.data()
//            let myLeg = myData?["username"]
//            print(".......\(myLeg!)")
//        }
        

        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signOutButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
