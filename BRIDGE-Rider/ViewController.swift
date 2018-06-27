//
//  ViewController.swift
//  BRIDGE-Rider
//
//  Created by Bharat Kathi on 6/26/18.
//  Copyright © 2018 Bharat Kathi. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    //Firebase Databse Reference Creation
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?

    override func viewDidLoad() {
        super.viewDidLoad()
        //Firebase Databse Reference Setup
        ref = Database.database().reference()
    }

}

