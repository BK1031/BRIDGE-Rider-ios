//
//  DriverLocationViewController.swift
//  BRIDGE-Rider
//
//  Created by Bharat Kathi on 8/1/18.
//  Copyright © 2018 Bharat Kathi. All rights reserved.
//

import UIKit
import Firebase

class DriverLocationViewController: UIViewController {
    
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
    }

}
