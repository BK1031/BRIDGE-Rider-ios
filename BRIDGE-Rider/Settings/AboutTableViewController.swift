//
//  AboutTableViewController.swift
//  BRIDGE-Rider
//
//  Created by Bharat Kathi on 9/13/18.
//  Copyright © 2018 Bharat Kathi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class AboutTableViewController: UITableViewController {
    
    @IBOutlet weak var appVersionLabel: UILabel!
    
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "General"
        self.navigationItem.largeTitleDisplayMode = .never
        ref = Database.database().reference()
        
        ref?.child("stableVersion").observeSingleEvent(of: .value, with: { (snapshot) in
            let stableVersion = snapshot.value as! Double
            if appVersion > stableVersion {
                self.appVersionLabel.text = "Canary \(appVersion)"
            }
            else {
                self.appVersionLabel.text = "\(appVersion)"
            }
        })
    }

}
