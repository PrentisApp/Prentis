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
import Alamofire
import PusherSwift
import PushNotifications

class HomePageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var userTable: UITableView!
    
    var docRef: DocumentReference!
    var db = Firestore.firestore()
    var documents = [] as [[String: Any]]
    var caller: Mentor!
    var pusher : Pusher!
    let pushNotifications = PushNotifications.shared
//    override func viewDidAppear(_ animated: Bool) {
//        print("hey view did appear")
//        if let name = UserDefaults.standard.string(forKey: "caller") {
//            UserDefaults.standard.removeObject(forKey: "caller")
//            setCallerAndSegue(menteeUID: name)
//        }
//    }
    @objc func listenForOfflineCall() {
        print("HEYYYY this is the offline one")
        if let name = UserDefaults.standard.string(forKey: "caller") {
            print("This should not be repeated")
            UserDefaults.standard.removeObject(forKey: "caller")

            setCallerAndSegue(menteeUID: name)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(listenForOfflineCall), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        listenForOfflineCall()
        listenForCall()
        try? self.pushNotifications.subscribe(interest: Auth.auth().currentUser!.uid)
        
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
    
    private func listenForCall() {
        let key = "200b87f4cd87ab883b75"
        let cluster = "us2"
        let uid = Auth.auth().currentUser!.uid
        pusher = Pusher(key: key, options: PusherClientOptions(host: .cluster(cluster)))
        
        let channel = pusher.subscribe("calls")
        let _ = channel.bind(eventName: uid, callback: { (data: Any?) -> Void in
            if let data = data as? [String: AnyObject] {
                let channelName = data["channel"] as! String
                let menteeUID = data["caller"] as! String
                self.setCallerAndSegue(menteeUID: menteeUID)
                
                
            }
        })
        
        pusher.connect()
    }
    
    func setCallerAndSegue(menteeUID: String) {
        let docRef = self.db.collection("User").document(menteeUID)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                self.caller = Mentor(mentorDoc: document.data() as! [String: Any])
                self.performSegue(withIdentifier: "receiveSegue", sender: self)
            } else {
                print("Document does not exist")
            }
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        //print("uid \(mentor.uid!)")
        if segue.identifier == "popupSegue" {
            let mentor = (sender as! UserCell).mentor! as Mentor
            (segue.destination as! PopupViewController).mentor = mentor
        } else if segue.identifier == "receiveSegue" {
            (segue.destination as! ReceiveCallController).caller = caller
        }
        
    }

}
