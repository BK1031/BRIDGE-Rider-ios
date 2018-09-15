//
//  RideHistoryViewController.swift
//  BRIDGE-Rider
//
//  Created by Bharat Kathi on 8/21/18.
//  Copyright © 2018 Bharat Kathi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class RideHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    
    var driverIDList = [String]()
    var rideIDList = [String]()
    var driverNameList = [String]()
    var dateList = [String]()
    var destinationList = [String]()
    var timeList = [String]()
    
    var rideID = ""
    var driverID = ""
    var date = ""
    var destination = ""
    var driverName = ""
    var time = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        databaseHandle = ref?.child("users").child(userID).child("history").observe(.value, with: { (snapshot) in
            if snapshot.childrenCount > 0 {
                self.driverIDList.removeAll()
                self.driverNameList.removeAll()
                self.rideIDList.removeAll()
                self.dateList.removeAll()
                self.destinationList.removeAll()
                self.timeList.removeAll()
                
                for ride in snapshot.children.allObjects as! [DataSnapshot] {
                    self.rideID = ride.key as String
                    let history = ride.value as? [String: AnyObject]
                    self.driverID = history!["driverID"] as! String
                    self.driverName = history!["driverName"] as! String
                    self.date = history!["date"] as! String
                    self.destination = history!["dest"] as! String
                    self.time = history!["endTime"] as! String
                    
                    self.rideIDList.append(self.rideID)
                    self.driverIDList.append(self.driverID)
                    self.dateList.append(self.date)
                    self.driverNameList.append(self.driverName)
                    self.destinationList.append(self.destination)
                    self.timeList.append(self.time)
                }
                self.tableView.reloadData()
            }
            else {
                self.driverIDList.removeAll()
                self.dateList.removeAll()
                self.driverNameList.removeAll()
                self.rideIDList.removeAll()
                self.destinationList.removeAll()
                self.timeList.removeAll()
                self.tableView.reloadData()
            }
        })
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return driverIDList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rideHistory") as! RideHistoryTableViewCell
        
        cell.profilePic.image = #imageLiteral(resourceName: "profile")
        cell.profilePic.layer.cornerRadius = cell.profilePic.frame.height / 2
        cell.driverName.text = driverNameList[indexPath.row]
        cell.rideDate.text = "\(dateList[indexPath.row]), \(timeList[indexPath.row])"
        cell.rideDest.text = destinationList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRide = rideIDList[indexPath.row]
        
        performSegue(withIdentifier: "rideDetails", sender: self)
    }
    
}
