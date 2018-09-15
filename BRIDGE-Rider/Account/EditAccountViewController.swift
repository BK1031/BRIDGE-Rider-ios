//
//  EditAccountViewController.swift
//  BRIDGE-Rider
//
//  Created by Bharat Kathi on 9/14/18.
//  Copyright © 2018 Bharat Kathi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class EditAccountViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    
    var storeRef:StorageReference?
    var store:StorageHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Edit Account"
        ref = Database.database().reference()
        storeRef = Storage.storage().reference()
        
        progressLabel.text = "Change Profile Above"
        progressView.progress = 0.0
        
        profileButton.setImage(profilePic, for: .normal)
        profileButton.layer.cornerRadius = 500
    }
    
    override func viewDidAppear(_ animated: Bool) {
        profileButton.setImage(profilePic, for: .normal)
        profileButton.imageView?.layer.cornerRadius = (profileButton.imageView?.frame.height)! / 2
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        }
        else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker {
            profilePic = selectedImage
            let imageData: Data = UIImageJPEGRepresentation(profilePic, 1.0)!
            
            let usersProfileRef = storeRef?.child("images").child("profiles")
            let uploadUserProfileTask = usersProfileRef?.child("\(userID).png").putData(imageData, metadata: nil) { (metadata, errro) in
                guard let metadata = metadata else {
                    print("Error occurred")
                    return
                }
            }
            
            let progressObserver = uploadUserProfileTask?.observe(.progress) { snapshot in
                self.progressView.progress = Float(Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount))
                self.progressLabel.text = "Uploading: \(self.progressView.progress * 100)%"
                if Float(Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)) == 1.0 {
                    self.progressLabel.text = "Finished Uploading!"
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changePic(_ sender: Any) {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .photoLibrary
        controller.allowsEditing = true
        present(controller, animated: true, completion: nil)
    }
    
}
