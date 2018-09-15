//
//  RideDetailsViewController.swift
//  BRIDGE-Rider
//
//  Created by Bharat Kathi on 8/22/18.
//  Copyright © 2018 Bharat Kathi. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase
import FirebaseDatabase

class RideDetailsViewController: UITableViewController, CLLocationManagerDelegate {

    @IBOutlet weak var driverPic: UIImageView!
    @IBOutlet weak var driverName: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var midTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabl: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    
    let locationManager = CLLocationManager()
    var userLocation:CLLocationCoordinate2D?
    
    var startCoor = CLLocationCoordinate2DMake(0.0, 0.0)
    var endCoor = CLLocationCoordinate2DMake(0.0, 0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.allowsBackgroundLocationUpdates = true
        
        mapView.layer.cornerRadius = 10
        mapView.settings.setAllGesturesEnabled(false)
        
        ref?.child("users").child(userID).child("history").child(selectedRide).observe(.value, with: { (snapshot) in
            if let rideDetails = snapshot.value as? [String: AnyObject] {
                self.driverName.text = rideDetails["driverName"] as? String
                self.destinationLabel.text = rideDetails["dest"] as? String
                self.startTimeLabel.text = rideDetails["startTime"] as? String
                self.midTimeLabel.text = rideDetails["midTime"] as? String
                self.endTimeLabl.text = rideDetails["endTime"] as? String
                self.dateLabel.text = rideDetails["date"] as? String
                let originLat = rideDetails["startLat"] as! Double
                let originLong = rideDetails["startLong"] as! Double
                let destLat = rideDetails["endLat"] as! Double
                let destLong = rideDetails["endLong"] as! Double
                self.startCoor = CLLocationCoordinate2DMake(originLat, originLong)
                self.endCoor = CLLocationCoordinate2DMake(destLat, destLong)
                
                self.navigationItem.title = "\(rideDetails["date"] as! String), \(rideDetails["endTime"] as! String)"
                
                let startMarker = GMSMarker()
                startMarker.position = self.startCoor
                startMarker.title = "Start Location"
                startMarker.snippet = "This is the location from which you requested a BRIDGE"
                startMarker.map = self.mapView
                
                let endMarker = GMSMarker()
                endMarker.position = self.endCoor
                endMarker.title = "Destination"
                endMarker.snippet = "This is the location of your destination"
                endMarker.map = self.mapView
                
                let sourceCoorString = "\(self.startCoor.latitude),\(self.startCoor.longitude)"
                let destCoorString = "\(self.endCoor.latitude),\(self.endCoor.longitude)"
                
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
                            self.distanceLabel.text = distance
                            //Show polyline
                            let path = GMSPath(fromEncodedPath: points)
                            var rectangle = GMSPolyline(path: path)
                            rectangle.map = nil
                            rectangle.strokeWidth = 4.0
                            rectangle.strokeColor = #colorLiteral(red: 0.9960784314, green: 0.8365689516, blue: 0.2848113179, alpha: 1)
                            rectangle.map = self.mapView
                            
                            self.mapView.animate(with: GMSCameraUpdate.fit(GMSCoordinateBounds(path: rectangle.path!), with: UIEdgeInsetsMake(75.0, 25.0, 25.0, 25.0)))
                            
                        }
                        
                    } catch let jsonError {
                        print("Error Serializing JSON")
                    }
                    
                    }.resume()
            }
        })
    }
    
}
