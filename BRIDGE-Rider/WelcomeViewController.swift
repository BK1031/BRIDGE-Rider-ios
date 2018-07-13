//
//  WelcomeViewController.swift
//  BRIDGE-Rider
//
//  Created by Bharat Kathi on 6/26/18.
//  Copyright © 2018 Bharat Kathi. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var getStartedButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var registrationView: UIView!
    @IBOutlet weak var registrationViewHeight: NSLayoutConstraint!
    
    //Firebase Database Reference Creation
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Firebase Database Reference Setup
        ref = Database.database().reference()
        
        getStartedButton.layer.cornerRadius = 10
        registrationView.layer.cornerRadius = 10
        createAccountButton.layer.cornerRadius = 10
        createAccountButton.isHidden = true
        loginButton.isHidden = true
        registrationViewHeight.constant = 0
    }
    
    @IBAction func getStarted(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut], animations: {
            self.registrationViewHeight.constant = self.view.frame.height - (self.view.safeAreaInsets.top + 180)
            self.view.layoutIfNeeded()
        }) { (finished) in
            //Execute once animation finished
            self.createAccountButton.isHidden = false
            self.loginButton.isHidden = false
        }
    }
    
    @IBAction func login(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut], animations: {
            self.registrationViewHeight.constant = 0
            self.createAccountButton.isHidden = true
            self.loginButton.isHidden = true
            self.view.layoutIfNeeded()
        }) { (finished) in
            //Execute once animation finished
        }
    }
    
}
