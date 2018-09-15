//
//  MyAccountTableViewController.swift
//  BRIDGE-Rider
//
//  Created by Bharat Kathi on 9/14/18.
//  Copyright © 2018 Bharat Kathi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class MyAccountTableViewController: UITableViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userIDLabel: UILabel!
    
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = name
        
        ref = Database.database().reference()
        
        nameLabel.text = name
        phoneLabel.text = phone
        emailLabel.text = email
        userIDLabel.text = userID
    }

    @IBAction func deleteAccount(_ sender: Any) {
        let sheet = UIAlertController(title: nil, message: "Are you sure you want to delete your BRIDGE Account? This action cannot be undone.", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let signOutAction = UIAlertAction(title: "Delete Account", style: .destructive) { (action) in
            let firebaseAuth = Auth.auth().currentUser
            firebaseAuth?.delete(completion: { (error) in
                if let error = error {
                    let alert = UIAlertController(title: "Error Deleting Account", message: "An error occured while trying to delete your BRIDGE Account: \(error.localizedDescription)", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Got it", style: .default, handler: nil)
                }
                else {
                    let values = [userID: nil] as [String: AnyObject]
                    self.ref?.child("users").updateChildValues(values)
                    
                    name = ""
                    email = ""
                    userID = ""
                    addressLine1 = ""
                    addressCity = ""
                    addressState = ""
                    addressZIP = ""
                    addressFull = ""
                    accountBalance = 0.0
                    self.performSegue(withIdentifier: "logOut", sender: self)
                }
            })
        }
        
        sheet.addAction(cancelAction)
        sheet.addAction(signOutAction)
        
        present(sheet, animated: true, completion: nil)
    }
    
}
