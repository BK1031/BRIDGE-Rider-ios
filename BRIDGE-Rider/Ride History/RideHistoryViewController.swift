//
//  RideHistoryViewController.swift
//  BRIDGE-Rider
//
//  Created by Bharat Kathi on 8/21/18.
//  Copyright © 2018 Bharat Kathi. All rights reserved.
//

import UIKit
import Firebase

class RideHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    
    var rideIDs = [String]()
    var rideDrivers = [String]()
    var rideDriverIDs = [String]()
    var rideDates = [String]()
    var rideDests = [String]()
    
    var rideID = ""
    var rideDriver = ""
    var rideDriverID = ""
    var rideDate = ""
    var rideDest = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.rideDriverIDs.append("iowfhwofhwo")
        self.rideDrivers.append("John McMillan")
        self.rideIDs.append("fewhihwifs")
        self.rideDates.append("5/23/18")
        self.rideDests.append("Valley Christian High School")
        self.tableView.reloadData()
        
//        ref?.child("users").child(userID).child("history").observe(.value, with: { (snapshot) in
//            if snapshot.childrenCount > 0 {
//                self.rideIDs.removeAll()
//                self.rideDrivers.removeAll()
//                self.rideDests.removeAll()
//                self.rideDriverIDs.removeAll()
//                self.rideDates.removeAll()
//
//                for ride in snapshot.children.allObjects as! [DataSnapshot] {
//                    let rideID = ride.key as String
//                    self.rideIDs.append(rideID)
//                    let rideInfo = ride.value as? [String: AnyObject]
//                    self.rideDriverID = rideInfo!["driverID"] as! String
//                    self.rideDate = rideInfo!["date"] as! String
//                    self.rideDest = rideInfo!["dest"] as! String
//
//                    print(self.rideDriverID)
//
//                    self.ref?.child("drivers").child(self.rideDriverID).observe(.value, with: { (snapshot) in
//                        let driverInfo = snapshot.value as? [String: AnyObject]
//                        self.rideDriver = driverInfo!["name"] as! String
//                    })
//                    self.rideDriverIDs.append(self.rideDriverID)
//                    self.rideDrivers.append(self.rideDriver)
//                    self.rideIDs.append(self.rideID)
//                    self.rideDates.append(self.rideDate)
//                    self.rideDests.append(self.rideDest)
//
//                    self.tableView.reloadData()
//                }
//                self.tableView.reloadData()
//            }
//            else {
//                self.rideIDs.removeAll()
//                self.rideDrivers.removeAll()
//                self.rideDests.removeAll()
//                self.rideDriverIDs.removeAll()
//                self.rideDates.removeAll()
//                self.tableView.reloadData()
//            }
//        })
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rideIDs.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rideHistory") as! RideHistoryTableViewCell
        
        cell.profilePic.image = #imageLiteral(resourceName: "profile")
        cell.profilePic.layer.cornerRadius = cell.profilePic.frame.height / 2
        cell.driverName.text = rideDrivers[indexPath.row]
        cell.rideDate.text = rideDates[indexPath.row]
        cell.rideDest.text = rideDests[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        cell.setHighlighted(false, animated: true)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRide = rideIDs[indexPath.row]
        driverID = rideDriverIDs[indexPath.row]
        
        performSegue(withIdentifier: "rideDetails", sender: self)
    }
    
}
