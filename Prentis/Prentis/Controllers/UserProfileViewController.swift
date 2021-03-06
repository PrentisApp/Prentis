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
import MXSegmentedControl

extension UIView {
    
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        
        DispatchQueue.main.async {
            let path = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
        }
    }
}

class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl1: MXSegmentedControl!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("You've arrived bih")
        // Do any additional setup after loading the view.
        segmentedControl1.append(title: "Profile")
        segmentedControl1.append(title: "Interests")
        segmentedControl1.append(title: "Expertise")
        segmentedControl1.indicator.linePosition = .bottom
        segmentedControl1.indicator.lineHeight = 3.0
        
        segmentedControl1.scrollView = self.scrollView
        
//        self.profileView.roundCorners(corners: [.topLeft, .topRight], radius: 8.0)
//        self.interestsView.roundCorners(corners: [.topLeft, .topRight], radius: 8.0)
//        self.expertiseView.roundCorners(corners: [.topLeft, .topRight], radius: 8.0)

        
    }

//    @IBAction func chooseView(_ sender: UISegmentedControl) {
//        if sender.selectedSegmentIndex == 0{
//            self.profileView.isHidden = false
//            self.interestsView.isHidden = true
//            self.expertiseView.isHidden = true
//            self.segmentControl.tintColor = self.profileView.tintColor
//        }
//        else if sender.selectedSegmentIndex == 1{
//            self.profileView.isHidden = true
//            self.interestsView.isHidden = false
//            self.expertiseView.isHidden = true
//            self.segmentControl.tintColor = self.interestsView.tintColor
//        }
//        else{
//            self.profileView.isHidden = true
//            self.interestsView.isHidden = true
//            self.expertiseView.isHidden = false
//            self.segmentControl.tintColor = self.expertiseView.tintColor
//        }
//    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}
