//
//  ViewController.swift
//  BRIDGE-Rider
//
//  Created by Bharat Kathi on 6/26/18.
//  Copyright © 2018 Bharat Kathi. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var requestButton: UIButton!
    
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
        
        self.navigationItem.title = "BRIDGE"
        requestButton.layer.cornerRadius = 10
        
        //Hardcoded School Coordinates
        if school == "Valley Christian High School" {
            schoolLat = 37.2761
            schoolLong = 121.8254
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let center = location.coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
    }
    
}

