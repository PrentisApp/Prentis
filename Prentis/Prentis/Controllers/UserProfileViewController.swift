//
//  UserProfileViewController.swift
//  Prentis
//
//  Created by Kevin Asistores on 10/10/18.
//  Copyright © 2018 PrentisApp. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class UserProfileViewController: UIViewController {

    @IBOutlet weak var interestsView: UIView!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var profileView: UIView!
    
    @IBOutlet weak var expertiseView: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("You've arrived bih")
        // Do any additional setup after loading the view.
    }

    @IBAction func chooseView(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            self.profileView.isHidden = false
            self.interestsView.isHidden = true
            self.expertiseView.isHidden = true
            self.segmentControl.tintColor = self.profileView.tintColor
        }
        else if sender.selectedSegmentIndex == 1{
            self.profileView.isHidden = true
            self.interestsView.isHidden = false
            self.expertiseView.isHidden = true
            self.segmentControl.tintColor = self.interestsView.tintColor
        }
        else{
            self.profileView.isHidden = true
            self.interestsView.isHidden = true
            self.expertiseView.isHidden = false
            self.segmentControl.tintColor = self.expertiseView.tintColor
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
