//
//  TopicCellTableViewCell.swift
//  Prentis
//
//  Created by Kevin Asistores on 11/18/18.
//  Copyright © 2018 PrentisApp. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class TopicCell: UITableViewCell {

    @IBOutlet weak var topicLabel: UILabel!
    
    @IBOutlet weak var topicInUse: UISwitch!
    
    var tableView: String!
    
    
    var docRef: DocumentReference!
    var db = Firestore.firestore()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var buttonAction: ((Any) -> Void)?
    @IBAction func checkTopic(_ sender: Any) {
        let docRef = db.collection("User").document((Auth.auth().currentUser?.uid)!)
        let defaults = UserDefaults.standard
        let list = tableView + "Array"
        var decider = defaults.stringArray(forKey: list) ?? [String]()
                
            if (!self.topicInUse.isOn){
                docRef.updateData([
                    tableView: FieldValue.arrayRemove([self.topicLabel.text!.lowercased()])
                    ])
                if let index = decider.index(of:self.topicLabel.text!.lowercased()) {
                    decider.remove(at: index)
                }
            }
            else{
                docRef.updateData([
                    tableView: FieldValue.arrayUnion([self.topicLabel.text!.lowercased()])
                    ])
                decider.append(self.topicLabel.text!.lowercased())
            }
        defaults.set(decider as! [String], forKey: list)

        self.buttonAction?(sender)
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
