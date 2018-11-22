//
//  IntExpViewController.swift
//  Prentis
//
//  Created by Kevin Asistores on 11/3/18.
//  Copyright © 2018 PrentisApp. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import M13Checkbox

class IntExpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var intExpTable: UITableView!
    
    @IBOutlet weak var expTable: UITableView!
    
    var states = [true:"Checked", false:"Unchecked"]
    
    func numberOfSections(in intExpTable: UITableView) -> Int {
        return objectsArray.count
    }
    
    func tableView(_ intExpTable: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(objectsArray[section].categoryObjects.count)
        return objectsArray[section].categoryObjects.count
    }
    
    func tableView(_ intExpTable: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = intExpTable.dequeueReusableCell(withIdentifier: "topicTableViewCell") as! TopicCell
        let x = Array(objectsArray[indexPath.section].categoryObjects.keys)[indexPath.row]
        let m = objectsArray[indexPath.section].categoryObjects[x]!
//        print("\(x) , \(m)")
        cell.topicLabel.text = x
        cell.tableView = "interests"
        cell.selectionStyle = .none
        cell.checkBox?.setCheckState(M13Checkbox.CheckState(rawValue: states[m]!)!, animated: false)
        cell.buttonAction = {sender in
            print("hey")
            self.objectsArray[indexPath.section].categoryObjects[x] = !m
        }
        return cell
    }
    
    func tableView(_ intExpTable: UITableView, titleForHeaderInSection section: Int) -> String? {
        return objectsArray[section].categoryName!
    }
    
    struct Objects {
        var categoryName : String!
        var categoryObjects : [String:Bool]!
    }
     var objectsArray = [Objects]()
    
    var docRef: DocumentReference!
    var db = Firestore.firestore()
    var documents = [] as [[String: Any]]
    var interests = [] as [String]

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        intExpTable.dataSource = self
        intExpTable.delegate = self
        
        let defaults = UserDefaults.standard
        self.interests = defaults.stringArray(forKey: "interestsArray") ?? [String]()
        print(self.interests)
        
        db.collection("Interexpertestis").order(by: "Category").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Hey you got an error querying all the users \(error)")
            } else {
                var currentCategory = ""
                var allInterests = [:] as [String:Bool]
                for document in querySnapshot!.documents {
                    print("\(document.data()["Category"] as! String) , \(document.documentID)")
                    if (currentCategory == ""){
                        currentCategory = document.data()["Category"] as! String
                        if (self.interests.contains(document.documentID.lowercased())){
                            allInterests[document.documentID] = true
                        }
                        else{
                            allInterests[document.documentID] = false
                        }
                    }
                    else {
                        if (document.data()["Category"] as! String == currentCategory){
                            if (self.interests.contains(document.documentID.lowercased())){
                                allInterests[document.documentID] = true
                            }
                            else{
                                allInterests[document.documentID] = false
                            }
                        }
                        else {
                            self.objectsArray.append(Objects(categoryName: currentCategory, categoryObjects: allInterests))
                            currentCategory = document.data()["Category"] as! String
                            allInterests = [:]
                            if (self.interests.contains(document.documentID.lowercased())){
                                allInterests[document.documentID] = true
                            }
                            else{
                                allInterests[document.documentID] = false
                            }
                        }
                    }
                }
                self.objectsArray.append(Objects(categoryName: currentCategory, categoryObjects: allInterests))
                print(self.objectsArray)
                self.intExpTable.reloadData()
            }
        }
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
