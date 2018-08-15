//
//  ViewController.swift
//  BRIDGE-Rider
//
//  Created by Bharat Kathi on 6/26/18.
//  Copyright © 2018 Bharat Kathi. All rights reserved.
//

import UIKit
import Firebase
import Mapbox
import UserNotifications

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MGLMapView!
    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    
    let locationManager = CLLocationManager()
    
    //Firebase Database Reference Creation
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?

    override func viewDidLoad() {
        super.viewDidLoad()
        //Firebase Database Reference Setup
        ref = Database.database().reference()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        mapView.showsUserLocation = true
        
        let center =  UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (result, error) in
            //handle result of request failure
        }
        
        self.navigationItem.title = "BRIDGE"
        requestButton.layer.cornerRadius = 10
        
        //Hardcoded School Coordinates
        if school == "Valley Christian High School" {
            schoolLat = 37.2761
            schoolLong = -121.8254
        }
        
        ref?.child("stableVersion").observeSingleEvent(of: .value, with: { (snapshot) in
            if let stableVersion = snapshot.value as? Double {
                if appVersion < stableVersion {
                    let alert = UIAlertController(title: "Outdated App", message: "It looks like you are using an outdated version of the BRIDGE Driver App. Please update to the latest version to avoid any bugs or crashes.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Got it", style: .default, handler: { (action) in
                        exit(1)
                    })
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
                else if appVersion > stableVersion {
                    let alert = UIAlertController(title: "BRIDGE Canary Detected", message: "It looks like you are using the BRIDGE Canary release of our Driver app. Note that this version should only be used for approved beta testing and not for everyday use.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Got it", style: .default, handler: { (action) in
                        //Don't do anything boi
                    })
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        profileButton.setImage(profilePic, for: .normal)
        profileButton.imageView?.layer.cornerRadius = (profileButton.imageView?.frame.height)! / 2
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let center = location.coordinate
        mapView.setCenter(center, zoomLevel: 15.0, animated: true)
    }
    
    @IBAction func requestRide(_ sender: Any) {
        self.performSegue(withIdentifier: "requestRide", sender: self)
    }
    
    @IBAction func accountView(_ sender: Any) {
        self.performSegue(withIdentifier: "toAccount", sender: self)
    }
    
}

