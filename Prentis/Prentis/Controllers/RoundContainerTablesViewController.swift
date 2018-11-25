//
//  RoundContainerTablesViewController.swift
//  Prentis
//
//  Created by Kevin Asistores on 11/22/18.
//  Copyright © 2018 PrentisApp. All rights reserved.
//

import UIKit

extension UIView {
    
    func roundOutCorners(corners: UIRectCorner, radius: CGFloat) {
        
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

class RoundContainerTablesViewController: UIViewController {

    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var interestsView: UIView!
    @IBOutlet weak var expertiseView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profileView.roundOutCorners(corners: [.topLeft, .topRight], radius: 8.0)
        self.interestsView.roundOutCorners(corners: [.topLeft, .topRight], radius: 8.0)
        self.expertiseView.roundOutCorners(corners: [.topLeft, .topRight], radius: 8.0)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
