//
//  RideConfirmedAlertViewController.swift
//  BRIDGE-Rider
//
//  Created by Bharat Kathi on 8/27/18.
//  Copyright © 2018 Bharat Kathi. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class RideConfirmedAlertViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var alerView: UIView!
    
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    
    let locationManager = CLLocationManager()
    var userLocation:CLLocationCoordinate2D?

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.allowsBackgroundLocationUpdates = true
        
        alerView.layer.cornerRadius = 10
    }

    @IBAction func dismissButton(_ sender: Any) {
        self.dismiss(animated: true) {
            let usersReference = self.ref?.child("rideRequests").child(userID)
            let values = ["riderName": nil, "riderAddress": nil, "lat": nil, "long": nil, "riderSchool": nil, "riderID": nil, "rideAccepted": nil, "dest": nil, "destLat": nil, "destLong": nil] as [String : AnyObject]
            usersReference?.updateChildValues(values)
            //Segue to Driver Location VC
            startLat = (self.locationManager.location?.coordinate.latitude)!
            startLong = (self.locationManager.location?.coordinate.longitude)!
            self.locationManager.stopUpdatingLocation()
            self.performSegue(withIdentifier: "toDriverView", sender: self)
            self.present(DriverLocationViewController(), animated: true, completion: nil)
        }
    }
    
}
