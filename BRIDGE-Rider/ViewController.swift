//
//  ViewController.swift
//  BRIDGE-Rider
//
//  Created by Bharat Kathi on 6/26/18.
//  Copyright © 2018 Bharat Kathi. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import UserNotifications
import MaterialComponents

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    
    let locationManager = CLLocationManager()
    var userLocation:CLLocationCoordinate2D?
    
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
        
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.padding.bottom = view.safeAreaInsets.bottom + 70
        
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
        
        ref?.child("stableVersion").observe(.value, with: { (snapshot) in
            if let stableVersion = snapshot.value as? Double {
                if appVersion < stableVersion {
                    self.performSegue(withIdentifier: "outdatedAlert", sender: self)
                }
                else if appVersion > stableVersion {
                    self.performSegue(withIdentifier: "betaAlert", sender: self)
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
        let camera = GMSCameraPosition(target: center, zoom: 16.0, bearing: 0, viewingAngle: 0)
        mapView.animate(to: camera)
    }
    
    @IBAction func requestRide(_ sender: Any) {
        self.performSegue(withIdentifier: "requestRide", sender: self)
    }
    
    @IBAction func accountView(_ sender: Any) {
        self.performSegue(withIdentifier: "toAccount", sender: self)
    }
    
}

