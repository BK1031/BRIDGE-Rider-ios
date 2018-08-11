//
//  DriverLocationViewController.swift
//  BRIDGE-Rider
//
//  Created by Bharat Kathi on 8/1/18.
//  Copyright © 2018 Bharat Kathi. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import CoreLocation
import UserNotifications

class DriverLocationViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    
    let locationManager = CLLocationManager()
    var riderLocation:CLLocationCoordinate2D?
    
    var driverLat = 0.0
    var driverLong = 0.0
    var driverCoordinates = CLLocationCoordinate2DMake(0.0, 0.0)
    
    var firstMapView = true

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.allowsBackgroundLocationUpdates = true
        
        let sourceCoordinates = locationManager.location?.coordinate
        
        mapView.delegate = self
        mapView.showsScale = true
        mapView.showsPointsOfInterest = true
        mapView.showsUserLocation = true
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = driverCoordinates
        annotation.title = "Driver"
        annotation.subtitle = "This is the location of your BRIDGE."
        self.mapView.addAnnotation(annotation)
        
        ref?.child("acceptedRides").child(userID).observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.mapView.removeAnnotation(annotation)
                self.driverLat = dictionary["driverLat"] as! Double
                self.driverLong = dictionary["driverLong"] as! Double
                self.driverCoordinates = CLLocationCoordinate2DMake(self.driverLat, self.driverLong)
                
                annotation.coordinate = self.driverCoordinates
                annotation.title = "Driver"
                annotation.subtitle = "This is the location of your BRIDGE."
                self.mapView.addAnnotation(annotation)
                
                if self.firstMapView {
                    let sourcePlacemark = MKPlacemark(coordinate: self.riderLocation!)
                    let destPlacemark = MKPlacemark(coordinate: self.driverCoordinates)
                    
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
                                print("Something Went WRONG!!! WHAAA!!!!")
                            }
                            return
                        }
                        let route = response.routes[0]
                        
                        let rekt = route.polyline.boundingMapRect
                        self.mapView.setRegion(MKCoordinateRegionForMapRect(rekt), animated: true)
                    }
                    self.firstMapView = false
                }
                
            }
        })
        
        ref?.child("acceptedRides").child(userID).child("driverArrived").observe(.value, with: { (snapshot) in
            if let driverArrived = snapshot.value as? Bool {
                if driverArrived {
                    //Driver has arrived!
                    let alert = UIAlertController(title: "BRIDGE Arrived", message: "Your BRIDGE has arrived!", preferredStyle: .alert)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        })
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locationManager.location?.coordinate {
            riderLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            let requestRef = ref?.child("acceptedRides").child(userID)
            let values = ["riderLat": riderLocation!.latitude, "riderLong": riderLocation!.longitude] as [String : Any]
            requestRef?.updateChildValues(values)
        }
        
    }

}
