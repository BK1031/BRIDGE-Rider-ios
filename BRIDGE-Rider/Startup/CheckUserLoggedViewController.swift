//
//  CheckUserLoggedViewController.swift
//  BRIDGE
//
//  Created by Bharat Kathi on 2/5/18.
//  Copyright © 2018 Bharat Kathi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class CheckUserLoggedViewController: UIViewController {
    
    var logged = false
    var logRequired = false

    override func viewDidLoad() {
        super.viewDidLoad()
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { snapshot in
            if let connected = snapshot.value as? Bool, connected {
                print("Connected")
                Auth.auth().addStateDidChangeListener { auth, user in
                    if user != nil {
                        
                        let user = Auth.auth().currentUser
                        if let user = user {
                            userID = user.uid
                            email = user.email!
                        }
                        
                        //Extract User Info form Firebase Here
                        
                        self.logged = true
                    }
                        
                    else {
                        self.logRequired = true
                    }
                }
            }
            
            else {
                print("Not connected")
                self.performSegue(withIdentifier: "connectionError", sender: self)
            }
        })
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if logged {
            self.performSegue(withIdentifier: "userLogged", sender: self)
        }
        else if logRequired {
            self.performSegue(withIdentifier: "toLog", sender: self)
        }
    }

}
