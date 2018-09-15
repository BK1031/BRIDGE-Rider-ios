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
import GoogleMaps
import CoreLocation

class RiderViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
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
    
    var alertDismissed = false
    
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
        
        mapView.isUserInteractionEnabled = true
        mapView.settings.myLocationButton = true
        mapView.padding.bottom = view.safeAreaInsets.bottom + 70
        
        //Save time info
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "hh:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        startTime = formatter.string(from: now)
        
        let usersReference = self.ref?.child("rideRequests").child(userID)
        let values = ["riderName": name, "lat": 0.0, "long": 0.0, "riderID": userID, "riderSchool": school, "rideAccepted": false, "dest": destination, "destLat": 0.0, "destLong": 0.0] as [String : Any]
        usersReference?.updateChildValues(values)
        
        ref?.child("rideRequests").child(userID).child("rideAccepted").observe(.value, with: { (snapshot) in
            if let driverConfirmed = snapshot.value as? Bool {
                if driverConfirmed {
                    //Driver Confirmed Ride
                    let usersReference = self.ref?.child("rideRequests").child(userID)
                    let values = ["riderName": nil, "riderAddress": nil, "lat": nil, "long": nil, "riderSchool": nil, "riderID": nil, "rideAccepted": nil, "dest": nil, "destLat": nil, "destLong": nil] as [String : AnyObject]
                    usersReference?.updateChildValues(values)
                    //Segue to Driver Location VC
                    startLat = (self.locationManager.location?.coordinate.latitude)!
                    startLong = (self.locationManager.location?.coordinate.longitude)!
                    self.locationManager.stopUpdatingLocation()
                    self.performSegue(withIdentifier: "toDriverView", sender: self)
                }
            }
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let center = location.coordinate
        let camera = GMSCameraPosition(target: center, zoom: 16.0, bearing: 0, viewingAngle: 0)
        mapView.animate(to: camera)
        if let location = locationManager.location?.coordinate {
            userLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
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
        destination = ""
        startTime = ""
        performSegue(withIdentifier: "cancelRide", sender: self)
    }
    
}
