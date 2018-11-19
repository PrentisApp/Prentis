//
//  Mentor.swift
//  Prentis
//
//  Created by Shakeeb Majid on 10/27/18.
//  Copyright © 2018 PrentisApp. All rights reserved.
//

import UIKit

class Mentor: NSObject {
    var uid: String?
    var username: String?
    var bio: String?
    var expertise: NSArray?
    var imagePath: String?
    
    init(mentorDoc: [String: Any]) {
        self.uid = mentorDoc["uid"] as? String
        self.username = mentorDoc["username"] as? String
        self.bio = mentorDoc["bio"] as? String
        self.expertise = mentorDoc["expertise"] as? NSArray
        self.imagePath = mentorDoc["profileImage"] as? String
    }

}
