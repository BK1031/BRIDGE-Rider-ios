//
//  ConnectionCheckerViewController.swift
//  BRIDGE
//
//  Created by Bharat Kathi on 3/12/18.
//  Copyright © 2018 Bharat Kathi. All rights reserved.
//

import UIKit
import Firebase

class ConnectionCheckerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { snapshot in
            if snapshot.value as? Bool ?? false {
                print("Connected")
                self.performSegue(withIdentifier: "connectedBack", sender: self)
            } else {
                print("Not connected")
                self.performSegue(withIdentifier: "backChecker", sender: self)
            }
        })
    }

}
