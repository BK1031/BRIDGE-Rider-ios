//
//  BetaAlertViewController.swift
//  BRIDGE-Rider
//
//  Created by Bharat Kathi on 8/26/18.
//  Copyright © 2018 Bharat Kathi. All rights reserved.
//

import UIKit

class BetaAlertViewController: UIViewController {

    @IBOutlet weak var alertView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertView.layer.cornerRadius = 10
    }

    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
