//
//  RiderViewController.swift
//  BRIDGE
//
//  Created by Bharat Kathi on 1/16/18.
//  Copyright © 2018 Bharat Kathi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import MapKit
import CoreLocation

class RiderViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var cancelRideButton: UIButton!
    
    let locationManager = CLLocationManager()
    var userLocation:CLLocationCoordinate2D?
    
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        cancelRideButton.layer.cornerRadius = 10
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        ref = Database.database().reference()
        let usersReference = self.ref?.child("rideRequests").child(userID)
        let values = ["riderName": name, "lat": 0.0, "long": 0.0, "riderID": userID, "rideAccepted": "false", "dest": destination] as [String : Any]
        usersReference?.updateChildValues(values)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let center = location.coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: false)
        mapView.showsUserLocation = true
        if let location = locationManager.location?.coordinate {
            userLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            ref = Database.database().reference()
            let usersReference = self.ref?.child("rideRequests").child(userID)
            let values = ["riderName": name, "lat": userLocation!.latitude, "long": userLocation!.longitude, "riderID": userID] as [String : Any]
            usersReference?.updateChildValues(values)
        }
        
    }

    @IBAction func cancelRideButton(_ sender: UIButton) {
        locationManager.stopUpdatingLocation()
        let values = ["riderName": nil, "riderAddress": nil, "lat": nil, "long": nil, "riderID": nil, "rideAccepted": nil, "dest": nil] as [String : Any?]
        let usersReference = self.ref?.child("rideRequests").child(userID)
        usersReference?.updateChildValues(values)
        performSegue(withIdentifier: "cancelRide", sender: self)
    }
    
}
