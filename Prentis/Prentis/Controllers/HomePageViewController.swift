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
    var caller: Mentor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.8
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 3
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
                    if (document.documentID != (Auth.auth().currentUser?.uid)!){
                        self.documents.append(document.data() as [String: Any])
                    }
                }
                self.userTable.reloadData()
            }
        }
        
        userTable.dataSource = self
        userTable.delegate = self
        let mentorUID = Auth.auth().currentUser!.uid
        db.collection("User").document(mentorUID).collection("Call").whereField("status", isEqualTo: "calling").addSnapshotListener { QuerySnapshot, error in
            print("hi did you run")
            guard let documents = QuerySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            if documents.count > 0 {
                let channelName = documents[0].documentID
                let menteeUID = documents[0].data()["menteeUID"] as! String
                //self.db.collection("User").document(Auth.auth().currentUser!.uid).collection("Call").document(channelName).updateData(["status": "accepted"])
                
                let docRef = self.db.collection("User").document(menteeUID)
                
                docRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                        self.caller = Mentor(mentorDoc: document.data() as! [String: Any])
                        self.performSegue(withIdentifier: "receiveSegue", sender: self)
                        print("Document data: \(dataDescription)")
                    } else {
                        print("Document does not exist")
                    }
                }
                
            } else {
                print("NOTHING TO DO HERE")
            }
            
            
            
        }
        
    }
    
    func numberOfSections(in userTable: UITableView) -> Int {
        return self.documents.count
    }
    
    func tableView(_ userTable: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 7
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }

    
    func tableView(_ userTable: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = userTable.dequeueReusableCell(withIdentifier: "UserTableViewCell") as! UserCell
        let document = self.documents[indexPath.section]
        
        cell.backgroundColor = UIColor.white
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 5
        cell.clipsToBounds = true
        cell.layer.masksToBounds = true
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 1
        cell.layer.shadowOffset = CGSize.zero
        cell.layer.shadowRadius = 10
        
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
    
    func tableView(_ userTable: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = userTable.cellForRow(at: indexPath as IndexPath) as! UserCell
        userTable.deselectRow(at: indexPath as IndexPath, animated: true)
        
        performSegue(withIdentifier: "popupSegue", sender: cell)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        //print("uid \(mentor.uid!)")
        if segue.identifier == "popupSegue" {
            let mentor = (sender as! UserCell).mentor! as Mentor
            (segue.destination as! PopupViewController).mentor = mentor
        } else if segue.identifier == "receiveSegue" {
            (segue.destination as! ReceiveCallController).caller = caller
        }
        
        
        
        
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
