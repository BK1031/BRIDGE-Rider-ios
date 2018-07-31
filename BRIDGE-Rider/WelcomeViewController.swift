//
//  WelcomeViewController.swift
//  BRIDGE-Rider
//
//  Created by Bharat Kathi on 6/26/18.
//  Copyright © 2018 Bharat Kathi. All rights reserved.
//

import UIKit
import PhoneNumberKit
import Firebase
import CoreLocation

class WelcomeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var getStartedButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var haveAccountButton: UIButton!
    
    @IBOutlet weak var registrationView: UIView!
    @IBOutlet weak var registrationViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: PhoneNumberTextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    @IBOutlet weak var termsLabel: UILabel!
    @IBOutlet weak var termsButton: UIButton!
    @IBOutlet weak var termsSwitch: UISwitch!
    
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var addressViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var schoolButton: UIButton!
    @IBOutlet weak var line1TextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipTextField: UITextField!
    @IBOutlet weak var schoolsPickerHeight: NSLayoutConstraint!
    @IBOutlet weak var schoolsPciker: UIPickerView!
    @IBOutlet weak var studentText: UILabel!
    @IBOutlet weak var studentSwitch: UISwitch!
    
    @IBOutlet weak var loginViewHeight: NSLayoutConstraint!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailLoginTextField: UITextField!
    @IBOutlet weak var passwordLoginTextField: UITextField!
    
    var confirm = false
    
    //Firebase Database Reference Creation
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        //Firebase Database Reference Setup
        ref = Database.database().reference()
        
        getStartedButton.layer.cornerRadius = 10
        registrationView.layer.cornerRadius = 10
        loginView.layer.cornerRadius = 10
        goButton.layer.cornerRadius = 10
        addressView.layer.cornerRadius = 10
        createAccountButton.layer.cornerRadius = 10
        createAccountButton.isHidden = true
        goButton.isHidden = true
        loginButton.layer.cornerRadius = 10
        loginButton.isHidden = true
        haveAccountButton.isHidden = true
        schoolsPciker.isHidden = true
        registrationViewHeight.constant = 0
        addressViewHeight.constant = 0
        loginViewHeight.constant = 0
        
        schoolsPciker.delegate = self
        schoolsPciker.dataSource = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return schoolsList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return schoolsList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        school = schoolsList[row]
        schoolButton.setTitle(school, for: .normal)
        UIView.animate(withDuration: 0.25, animations: {
            self.schoolsPciker.isHidden = true
            self.schoolsPickerHeight.constant = 0
            self.view.layoutIfNeeded()
        }) { (finished) in
            //Exectute code once finished
        }
    }
    
    @IBAction func getStarted(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut], animations: {
            self.registrationViewHeight.constant = self.view.frame.height - (self.view.safeAreaInsets.top + 180)
            self.view.layoutIfNeeded()
        }) { (finished) in
            //Execute once animation finished
            self.createAccountButton.isHidden = false
            self.haveAccountButton.isHidden = false
        }
    }
    
    @IBAction func confirmed(_ sender: Any) {
        if termsSwitch.isOn {
            confirm = true
        }
        else {
            confirm = false
        }
    }
    
    @IBAction func createAccount(_ sender: Any) {
        if nameTextField.text! == "" || phoneTextField.text! == "" || emailTextField.text! == "" || passwordTextField.text! == "" {
            let alert = UIAlertController(title: "Missing Information", message: "Information is missing from your entry. Please fill in all of the fields below to create your BRIDGE Account.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Got it", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        else if passwordTextField.text != confirmTextField.text! {
            let alert = UIAlertController(title: "Passwords Do Not Match", message: "Your passwords do not match.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Got it", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        else if confirm != true {
            let alert = UIAlertController(title: "Terms and Conditions", message: "You must agree to the terms and conditions to create a BRIDGE Account.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Got it", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        else {
            tempPassword = passwordTextField.text!
            name = nameTextField.text!
            email = emailTextField.text!
            phone = phoneTextField.text!
            
            UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut], animations: {
                self.registrationViewHeight.constant = 0
                self.createAccountButton.isHidden = true
                self.haveAccountButton.isHidden = true
                self.view.layoutIfNeeded()
            }) { (finished) in
                //Execute once animation finished
                UIView.animate(withDuration: 0.25, animations: {
                    self.addressViewHeight.constant = self.view.frame.height - (self.view.safeAreaInsets.top + 180)
                    self.goButton.isHidden = false
                    self.view.layoutIfNeeded()
                }, completion: { (finished) in
                    //Execute once finishes (yes, again)
                })
            }
            
        }
    }
    
    @IBAction func selectSchool(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25, animations: {
            self.schoolsPciker.isHidden = false
            self.schoolsPickerHeight.constant = 125
            self.view.layoutIfNeeded()
        }) { (finished) in
            self.studentText.text = "I am a student at \(school)"
        }
    }
    
    @IBAction func go(_ sender: Any) {
        addressLine1 = line1TextField.text!
        addressCity = cityTextField.text!
        addressState = stateTextField.text!
        addressZIP = zipTextField.text!
        addressFull = ("\(addressLine1), \(addressCity), \(addressState), \(addressZIP)")
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressFull) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    homeLat = location.coordinate.latitude
                    homeLong = location.coordinate.longitude
                }
            }
            else {
                let alert = UIAlertController(title: "Geocoding Error", message: "There was an error geocoding your provided address: \(error!)", preferredStyle: .alert)
                let action = UIAlertAction(title: "Got it", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        Auth.auth().createUser(withEmail: email, password: tempPassword) { (user, error) in
            if error == nil {
                let user = Auth.auth().currentUser
                if let user = user {
                    userID = user.uid
                }
                let usersReference = self.ref?.child("users").child(userID)
                let values = ["name": name, "email": email, "address": addressFull, "accountBalance": accountBalance, "phone": phone, "school": school, "homeLat": homeLat, "homeLong": homeLong, "isStudent": isStudent] as [String : Any]
                usersReference?.updateChildValues(values)
                
                self.performSegue(withIdentifier: "getStarted", sender: self)
            }
            else {
                let alert = UIAlertController(title: "Account Creation Error", message: "There was an error creating your BRIDGE Account: \(error!)", preferredStyle: .alert)
                let action = UIAlertAction(title: "Got it", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func student(_ sender: Any) {
        if studentSwitch.isOn {
            isStudent = true
        }
        else {
            isStudent = false
        }
    }
    
    @IBAction func login(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut], animations: {
            self.registrationViewHeight.constant = 0
            self.createAccountButton.isHidden = true
            self.haveAccountButton.isHidden = true
            self.view.layoutIfNeeded()
        }) { (finished) in
            //Execute once animation finished
            UIView.animate(withDuration: 0.25, animations: {
                self.loginViewHeight.constant = self.view.frame.height - (self.view.safeAreaInsets.top + 180)
                self.loginButton.isHidden = false
                self.view.layoutIfNeeded()
            }, completion: { (finished) in
                //Execute once animation is finished (yes, again lol)
            })
        }
    }
    
    @IBAction func loginUser(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailLoginTextField.text!, password: passwordLoginTextField.text!) { (user, error) in
            let user = Auth.auth().currentUser
            if user != nil {
                
                let user = Auth.auth().currentUser
                if let user = user {
                    userID = user.uid
                    email = user.email!
                }
                
                //Extract User Info form Firebase Here
                Database.database().reference().child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let userData = snapshot.value as? [String: AnyObject] {
                        name = userData["name"] as! String
                        phone = userData["phone"] as! String
                        school = userData["school"] as! String
                        homeLat = userData["homeLat"] as! Double
                        homeLong = userData["homeLong"] as! Double
                        accountBalance = userData["accountBalance"] as! Double
                        isStudent = userData["isStudent"] as! Bool
                    }
                })
                self.performSegue(withIdentifier: "getStarted", sender: self)
            }
            else {
                let alert = UIAlertController(title: "Login Error", message: "There was an error logging you into your BRIDGE Account: \(error!)", preferredStyle: .alert)
                let action = UIAlertAction(title: "Got it", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}
