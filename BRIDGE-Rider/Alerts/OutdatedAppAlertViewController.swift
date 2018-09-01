//
//  OutdatedAppAlertViewController.swift
//  BRIDGE-Rider
//
//  Created by Bharat Kathi on 8/27/18.
//  Copyright © 2018 Bharat Kathi. All rights reserved.
//

import UIKit

class OutdatedAppAlertViewController: UIViewController {
    
    @IBOutlet weak var alertView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertView.layer.cornerRadius = 10
    }

    @IBAction func dismissButton(_ sender: Any) {
        exit(1)
    }
    
}
