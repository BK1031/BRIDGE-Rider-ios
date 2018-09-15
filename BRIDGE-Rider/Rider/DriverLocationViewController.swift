//
//  DriverLocationViewController.swift
//  BRIDGE-Rider
//
//  Created by Bharat Kathi on 8/1/18.
//  Copyright © 2018 Bharat Kathi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import GoogleMaps
import CoreLocation
import UserNotifications

class DriverLocationViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var driverButton: UIButton!
    
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
        
        driverButton.layer.cornerRadius = 10
        
        let sourceCoordinates = locationManager.location?.coordinate
        
        mapView.isMyLocationEnabled = true
        
        let driverMarker = GMSMarker()
        driverMarker.position = driverCoordinates
        driverMarker.title = "Driver"
        driverMarker.snippet = "This is the location of your BRIDGE"
        driverMarker.map = self.mapView
        
        ref?.child("acceptedRides").child(userID).observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.driverLat = dictionary["driverLat"] as! Double
                self.driverLong = dictionary["driverLong"] as! Double
                driverID = dictionary["driverID"] as! String
                driverName = dictionary["driverName"] as! String
                self.driverCoordinates = CLLocationCoordinate2DMake(self.driverLat, self.driverLong)
                driverMarker.position = self.driverCoordinates
                
                if self.firstMapView {
                    let sourceCoorString = "\(sourceCoordinates!.latitude),\(sourceCoordinates!.longitude)"
                    let destCoorString = "\(self.driverLat),\(self.driverLong)"
                    
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
                    
                    self.firstMapView = false
                }
                
            }
        })
        
        ref?.child("acceptedRides").child(userID).child("driverArrived").observe(.value, with: { (snapshot) in
            if let driverArrived = snapshot.value as? Bool {
                if driverArrived {
                    //Driver has arrived - Do some shit here:
                    let alert = UIAlertController(title: "Driver Arrived", message: "Your BRIDGE has arrived!", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Got it", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        })
        
        ref?.child("acceptedRides").child(userID).child("pickedUp").observe(.value, with: { (snapshot) in
            if let pickedUp = snapshot.value as? Bool {
                if pickedUp {
                    //Save time info
                    let now = Date()
                    let formatter = DateFormatter()
                    formatter.timeZone = TimeZone.current
                    formatter.dateFormat = "hh:mm a"
                    formatter.amSymbol = "AM"
                    formatter.pmSymbol = "PM"
                    midTime = formatter.string(from: now)
                    //Rider has been picked up!
                    self.performSegue(withIdentifier: "finalStretch", sender: self)
                }
            }
        })
        
    }
    
    @IBAction func driverInfo(_ sender: Any) {
        //Segue to driver info here
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
