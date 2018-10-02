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
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imageRef = storageRef.child("ProfileImages/9Eif7xFDcRVTgbLfli6g5mrf4Dq1.jpg")
        
        imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
            // Uh-oh, an error occurred!
            } else {
            // Data for "images/island.jpg" is returned
            let image = UIImage(data: data!)
            cell.profileImage.image = image
            }
        }
            
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        docRef = Firestore.firestore().document("User/iFwuYQkAxOavvjBtEG00jHjGFp42").collection("Channel").document("ChannelName")
//        var channelname = ["channelname": "This is the channel name!", "uid": 1] as [String : Any]
//        docRef.setData(channelname)
//
//
//        db.collection("User").document("iFwuYQkAxOavvjBtEG00jHjGFp42").collection("Channel").document("ChannelName").addSnapshotListener { documentSnapshot, error in
//                guard let document = documentSnapshot else {
//                    print("error getting document on change \(error)")
//                    return
//                }
//                guard let data = document.data() else {
//                    print("document data is empty")
//                    print("document data \(document.data())")
//                    print("called")
//                    return
//                }
//                print("current data: \(data)")
//                print("hiiiii you listened!")
//        }
//
//        channelname = ["channelname": "This is the channel name1!", "uid": 2] as [String : Any]
//        docRef.setData(channelname)
//
//        channelname = ["channelname": "This is the channel name2!", "uid": 3] as [String : Any]
//        docRef.setData(channelname)
//        

//        docRef = Firestore.firestore().document("User/\(Auth.auth().currentUser?.uid)").collection("Channel").document("ChannelName")
//        var channelname = ["channelname": "This is the channel name!", "uid": 1] as [String : Any]
//        docRef.setData(channelname)
        
        
        
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
