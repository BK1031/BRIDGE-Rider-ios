//
//  AccountViewController.swift
//  BRIDGE
//
//  Created by Bharat Kathi on 1/11/18.
//  Copyright © 2018 Bharat Kathi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class AccountViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var accountBalanceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var schoolAddressLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var signOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        signOutButton.layer.cornerRadius = 10
        nameLabel.text = name
        emailLabel.text = email
        phoneLabel.text = phone
        addressLabel.text = addressFull
        schoolLabel.text = school
        schoolAddressLabel.text = "100 Skyway Drive, San Jose, CA 95111"
        accountBalanceLabel.text = "$\(accountBalance)"
        profileImageView.image = profilePic
        profileImageView.layer.cornerRadius = (profileImageView.frame.height) / 2
    }
    
    override func viewDidAppear(_ animated: Bool) {
        profileImageView.image = profilePic
        profileImageView.layer.cornerRadius = (profileImageView.frame.height) / 2
    }
    

    @IBAction func doneButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addFundsButton(_ sender: UIButton) {
        //TODO: Add apple pay shit here
    }
    
    @IBAction func editAccountButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "editAccount" , sender: self)
    }
    
    @IBAction func signOutButton(_ sender: UIButton) {
        let sheet = UIAlertController(title: nil, message: "Are you sure you want to sign out?", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let signOutAction = UIAlertAction(title: "Sign Out", style: .destructive) { (action) in
            name = ""
            email = ""
            userID = ""
            profilePic = #imageLiteral(resourceName: "profile")
            addressLine1 = ""
            addressCity = ""
            addressState = ""
            addressZIP = ""
            addressFull = ""
            accountBalance = 0.0
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                self.performSegue(withIdentifier: "logOut", sender: self)
            } catch let signOutError as NSError {
                //Sign-Out error occured
            }
        }
        
        sheet.addAction(cancelAction)
        sheet.addAction(signOutAction)
        
        present(sheet, animated: true, completion: nil)
    }
}
