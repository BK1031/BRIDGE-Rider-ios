//
//  FinalDestViewController.swift
//  BRIDGE-Rider
//
//  Created by Bharat Kathi on 8/10/18.
//  Copyright © 2018 Bharat Kathi. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import MapKit
import Firebase

class FinalDestViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var descriptionText: UILabel!
    
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    
    let locationManager = CLLocationManager()
    var userLocation:CLLocationCoordinate2D?
    
    var destCoordinates:CLLocationCoordinate2D!
    
    var arrived = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.allowsBackgroundLocationUpdates = true
        
        mapView.delegate = self
        mapView.showsScale = true
        mapView.showsPointsOfInterest = true
        mapView.showsUserLocation = true
        
        descriptionView.layer.cornerRadius = 10
        doneButton.layer.cornerRadius = 10
        
        let sourceCoordinates = locationManager.location?.coordinate
        if destination == "Home" {
            destCoordinates = CLLocationCoordinate2DMake(Double(homeLat), Double(homeLong))
        }
        else {
            destCoordinates = CLLocationCoordinate2DMake(Double(schoolLat), Double(schoolLong))
        }
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinates!)
        let destPlacemark = MKPlacemark(coordinate: destCoordinates)
        
        let sourceItem = MKMapItem(placemark: sourcePlacemark)
        let destItem = MKMapItem(placemark: destPlacemark)
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceItem
        directionRequest.destination = destItem
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("Something Went Wrong! \(error)")
                }
                return
            }
            let route = response.routes[0]
            self.mapView.add(route.polyline, level: .aboveRoads)
            
            let rekt = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rekt), animated: true)
        }
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = destCoordinates
        annotation.title = destination
        annotation.subtitle = "This is the location of your destination."
        mapView.addAnnotation(annotation)
        
        let geoFenceRegion:CLCircularRegion = CLCircularRegion(center: destCoordinates, radius: 10, identifier: "Destination")
        locationManager.startMonitoring(for: geoFenceRegion)
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        //Rider arrived at destination! We done bois!
        arrived = true
        doneButton.setTitle("Done", for: .normal)
        descriptionText.text = "You have arrived at your final destination. Thank you for using BRIDGE!"
    }

    @IBAction func doneRide(_ sender: Any) {
        if arrived {
            //TODO: Save ride history here
            
            //Delete Request Data
            let requestRef = ref?.child("acceptedRides").child(userID)
            let values = ["riderName": nil, "riderLat": nil, "riderLong": nil, "driverID": nil, "driverLat": nil, "driverLong": nil, "driverArrived": nil, "pickedUp": nil, "dest": nil] as [String : AnyObject]
            requestRef?.updateChildValues(values)
            
            self.performSegue(withIdentifier: "rideDone", sender: self)
        }
        else {
            let alert = UIAlertController(title: "End Ride", message: "Are you sure you want to end the ride? It looks like you're not at your destination yet.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            let action2 = UIAlertAction(title: "End Ride", style: .destructive) { (done) in
                //TODO: Copy ride history saving shit here
                
                //Delete Request Data
                let requestRef = self.ref?.child("acceptedRides").child(userID)
                let values = ["riderName": nil, "riderLat": nil, "riderLong": nil, "driverID": nil, "driverLat": nil, "driverLong": nil, "driverArrived": nil, "pickedUp": nil, "dest": nil] as [String : AnyObject]
                requestRef?.updateChildValues(values)
                
                self.performSegue(withIdentifier: "rideDone", sender: self)
            }
            alert.addAction(action)
            alert.addAction(action2)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locationManager.location?.coordinate {
            userLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        }
    }
    
}
