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
import GoogleMaps
import Firebase

class FinalDestViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var descriptionViewHeigh: NSLayoutConstraint!
    
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    
    let locationManager = CLLocationManager()
    var userLocation:CLLocationCoordinate2D?
    
    var destCoordinates:CLLocationCoordinate2D!
    
    var geoFenceRegion:CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(0.0, 0.0), radius: 10, identifier: "Destination")
    
    var arrived = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.allowsBackgroundLocationUpdates = true
        
        mapView.isMyLocationEnabled = true
        
        descriptionView.layer.cornerRadius = 10
        doneButton.layer.cornerRadius = 10
        
        let sourceCoordinates = locationManager.location?.coordinate
        
        if destination == "Home" {
            destCoordinates = CLLocationCoordinate2DMake(Double(homeLat), Double(homeLong))
        }
        else {
            destCoordinates = CLLocationCoordinate2DMake(Double(schoolLat), Double(schoolLong))
        }
        
        let destMarker = GMSMarker()
        destMarker.position = destCoordinates
        destMarker.title = "Destination"
        destMarker.snippet = "This is the location of your rider's destinaton"
        destMarker.map = self.mapView
        
        let sourceCoorString = "\(sourceCoordinates!.latitude),\(sourceCoordinates!.longitude)"
        let destCoorString = "\(destCoordinates.latitude),\(destCoordinates.longitude)"
        
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(sourceCoorString)&destination=\(destCoorString)&key=AIzaSyDpnFep4SN9iBjtN6MKG9bwdS1ocxNXuRs"
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, erro) in
            //Extract data here
            guard let data = data else {return}
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String: AnyObject]
                
                print(json)
                
                //Extract JSON Data
                let arrayRoutes = json["routes"] as! NSArray
                let arrLegs = (arrayRoutes[0] as! NSDictionary).object(forKey: "legs") as! NSArray
                let arrSteps = arrLegs[0] as! NSDictionary
                
                let dicDistance = arrSteps["distance"] as! NSDictionary
                let distance = dicDistance["text"] as! String
                
                let dicDuration = arrSteps["duration"] as! NSDictionary
                let duration = dicDuration["text"] as! String
                
                print("\(distance), \(duration)")
                
                //Extract Polyline Data
                let array = json["routes"] as! NSArray
                let dic = array[0] as! NSDictionary
                let dic1 = dic["overview_polyline"] as! NSDictionary
                let points = dic1["points"] as! String
                print(points)
                
                //Return to main thread
                DispatchQueue.main.async {
                    //Show polyline
                    let path = GMSPath(fromEncodedPath: points)
                    var rectangle = GMSPolyline(path: path)
                    rectangle.map = nil
                    rectangle.strokeWidth = 4.0
                    rectangle.strokeColor = #colorLiteral(red: 0.9960784314, green: 0.8365689516, blue: 0.2848113179, alpha: 1)
                    rectangle.map = self.mapView
                    
                    self.mapView.animate(with: GMSCameraUpdate.fit(GMSCoordinateBounds(path: rectangle.path!), withPadding: 50))
                    
                }
                
            } catch let jsonError {
                print("Error Serializing JSON")
            }
            }.resume()
        
        self.geoFenceRegion = CLCircularRegion(center: destCoordinates, radius: 10, identifier: "Destination")
        locationManager.startMonitoring(for: geoFenceRegion)
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        //Rider arrived at destination! We done bois!
        arrived = true
        doneButton.setTitle("Done", for: .normal)
        UIView.animate(withDuration: 0.1) {
            self.descriptionViewHeigh.constant = 100
            self.descriptionText.text = "You have arrived at your final destination. Thank you for using BRIDGE!"
            self.view.layoutIfNeeded()
        }
        locationManager.stopMonitoring(for: geoFenceRegion)
    }

    @IBAction func doneRide(_ sender: Any) {
        if arrived {
            //TODO: Save ride history here
            self.endRide()
        }
        else {
            let alert = UIAlertController(title: "End Ride", message: "Are you sure you want to end the ride? It looks like you're not at your destination yet.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            let action2 = UIAlertAction(title: "End Ride", style: .destructive) { (done) in
                //TODO: Copy ride history saving shit here
                self.endRide()
            }
            alert.addAction(action)
            alert.addAction(action2)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func endRide() {
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "hh:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        endTime = formatter.string(from: now)
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "MM/dd/yy"
        let rideDate = formatter.string(from: now)
        
        endLat = (self.locationManager.location?.coordinate.latitude)!
        endLong = (self.locationManager.location?.coordinate.longitude)!
        
        let historyValues = ["driverName": driverName, "date": rideDate, "startTime": startTime, "midTime": midTime, "endTime": endTime, "driverID": driverID, "dest": destination, "startLat": startLat, "startLong": startLong, "endLat": endLat, "endLong": endLong] as [String : AnyObject]
        let historyRef = self.ref?.child("users").child(userID).child("history").child("\(now)")
        historyRef?.updateChildValues(historyValues)
        
        //Delete Request Data
        destination = ""
        driverName = ""
        startTime = ""
        midTime = ""
        endTime = ""
        startLat = 0.0
        startLong = 0.0
        endLat = 0.0
        endLong = 0.0
        
        self.locationManager.stopUpdatingLocation()
        let requestRef = self.ref?.child("acceptedRides")
        let values = [userID: nil] as [String : AnyObject]
        requestRef?.updateChildValues(values)
        
        self.performSegue(withIdentifier: "rideDone", sender: self)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locationManager.location?.coordinate {
            userLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        }
    }
    
}
