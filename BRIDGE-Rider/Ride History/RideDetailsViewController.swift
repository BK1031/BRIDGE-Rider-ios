//
//  RideDetailsViewController.swift
//  BRIDGE-Rider
//
//  Created by Bharat Kathi on 8/22/18.
//  Copyright © 2018 Bharat Kathi. All rights reserved.
//

import UIKit

class RideDetailsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.title = "\(selectedRide)"
    }
}
