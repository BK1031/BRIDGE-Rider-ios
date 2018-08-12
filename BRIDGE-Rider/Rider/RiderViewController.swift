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
    @IBOutlet weak var selectionView: UIView!
    @IBOutlet weak var selectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var selectionButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var schoolButton: UIButton!
    
    let locationManager = CLLocationManager()
    var userLocation:CLLocationCoordinate2D?
    
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        cancelRideButton.layer.cornerRadius = 10
        selectionView.layer.cornerRadius = 10
        selectionViewHeight.constant = 75
        homeButton.isHidden = true
        schoolButton.isHidden = true
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.allowsBackgroundLocationUpdates = true
        
        ref = Database.database().reference()
        
        let usersReference = self.ref?.child("rideRequests").child(userID)
        let values = ["riderName": name, "lat": 0.0, "long": 0.0, "riderID": userID, "riderSchool": school, "rideAccepted": false, "dest": destination, "destLat": 0.0, "destLong": 0.0] as [String : Any]
        usersReference?.updateChildValues(values)
        
        ref?.child("rideRequests").child(userID).child("rideAccepted").observe(.value, with: { (snapshot) in
            if let driverConfirmed = snapshot.value as? Bool {
                if driverConfirmed {
                    //Driver Confirmed Ride
                    self.locationManager.stopUpdatingLocation()
                    let alert = UIAlertController(title: "Ride Confirmed", message: "Your ride request has been confirmed.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Got it", style: .default, handler: { (action) in
                        let usersReference = self.ref?.child("rideRequests").child(userID)
                        let values = ["riderName": nil, "riderAddress": nil, "lat": nil, "long": nil, "riderSchool": nil, "riderID": nil, "rideAccepted": nil, "dest": nil, "destLat": nil, "destLong": nil] as [String : AnyObject]
                        usersReference?.updateChildValues(values)
                        //Segue to Driver Location VC
                        self.performSegue(withIdentifier: "toDriverView", sender: self)
                    })
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        })
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
            let values = ["lat": userLocation!.latitude, "long": userLocation!.longitude] as [String : Any]
            usersReference?.updateChildValues(values)
        }
        
    }
    
    @IBAction func selectDest(_ sender: Any) {
        UIView.animate(withDuration: 0.1, animations: {
            self.selectionViewHeight.constant = 125
            self.view.layoutIfNeeded()
        }) { (completed) in
            //Execute once finished
            UIView.animate(withDuration: 0.1, animations: {
                self.schoolButton.isHidden = false
                self.homeButton.isHidden = false
                self.view.layoutIfNeeded()
            }, completion: { (completed) in
                //Execute once finished (yes again lol)
            })
        }
    }
    
    @IBAction func home(_ sender: Any) {
        destination = "Home"
        let values = ["dest": destination, "destLat": homeLat, "destLong": homeLong] as [String : Any?]
        let usersReference = self.ref?.child("rideRequests").child(userID)
        usersReference?.updateChildValues(values)
        
        UIView.animate(withDuration: 0.1, animations: {
            self.schoolButton.isHidden = true
            self.homeButton.isHidden = true
            self.selectionViewHeight.constant = 75
            self.view.layoutIfNeeded()
        }) { (completed) in
            //Execute once finished
            self.selectionButton.setTitle("Destination: \(destination)", for: .normal)
        }
    }
    
    @IBAction func schoolSelected(_ sender: Any) {
        destination = school
        let values = ["dest": school, "destLat": schoolLat, "destLong": schoolLong] as [String : Any?]
        let usersReference = self.ref?.child("rideRequests").child(userID)
        usersReference?.updateChildValues(values)
        
        UIView.animate(withDuration: 0.1, animations: {
            self.schoolButton.isHidden = true
            self.homeButton.isHidden = true
            self.selectionViewHeight.constant = 75
            self.view.layoutIfNeeded()
        }) { (completed) in
            //Execute once finished
            self.selectionButton.setTitle("Destination: \(destination)", for: .normal)
        }
    }
    
    @IBAction func cancelRideButton(_ sender: UIButton) {
        locationManager.stopUpdatingLocation()
        let values = ["riderName": nil, "riderAddress": nil, "lat": nil, "long": nil, "riderSchool": nil, "riderID": nil, "rideAccepted": nil, "dest": nil, "destLat": nil, "destLong": nil] as [String : Any?]
        let usersReference = self.ref?.child("rideRequests").child(userID)
        usersReference?.updateChildValues(values)
        performSegue(withIdentifier: "cancelRide", sender: self)
    }
    
}
