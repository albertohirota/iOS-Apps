//
//  ViewController.swift
//  Showcase
//
//  Created by Alberto Hirota on 8/17/16.
//  Copyright © 2016 Alberto Hirota. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import Foundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var nameField: MaterialTextField!
    @IBOutlet weak var imageSelect: UIImageView!
    @IBOutlet weak var imageLbl: UILabel!
    var _userNa: String?
    var _userIm: UIImage?
    var imagePicker: UIImagePickerController!
    var metaD: FIRStorageMetadata?
    var userPhotoUrl: String?
    var userNa: String {
        return _userNa!
    }
    var userIm: UIImage {
        return _userIm!
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //If the user is already logged in take them straight to the next screen
        self.navigationItem.setHidesBackButton (true, animated: true)
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
            self.performSegueWithIdentifier("loggedIn", sender: nil)
        }
    }
    @IBAction func fbBtnPressed(sender: UIButton!) {
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logInWithReadPermissions(["email"], fromViewController: self) { (facebookResult: FBSDKLoginManagerLoginResult!, facebookError: NSError!) -> Void in
            if facebookError != nil {
                print("Facebook login failed. Error \(facebookError)")
            } else {
              let accessToken = FBSDKAccessToken.currentAccessToken().tokenString //NEW WAY
                let credential = FIRFacebookAuthProvider.credentialWithAccessToken(accessToken)
                
                //DataService.ds.REF_BASE.authWithAuthProvider("facebook", String!, accessToken: String!, withCompletionBlock: { error, authData in
                //login in facebook, but need to store, but need to store data in Firebase, OLD WAY
                FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                if error != nil {
                        print("Login failed. \(error)")
                    } else {
                        print("Logged In! \(user)")
                    
                        //Store what type of account this is
                        let user1 = ["provider": credential.provider]
                    DataService.ds.createFirebaseUser((user?.uid)!, user:user1)
                    
                    //FBSDKProfilePictureView
                    //FBSDKProfile
                    
                        NSUserDefaults.standardUserDefaults().setValue(user!.uid, forKey: KEY_UID)
                        // not logged to a new view controller
                        self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                    }
                }
           }
        }
    }
    @IBAction func attemptLogin(sender: UIButton!) {
        //Make sure there is an email and a password
        if let email = emailField.text where email != "", let pwd = passwordField.text where pwd != "", let userNam = nameField.text {
            
            FIRAuth.auth()?.signInWithEmail(email, password: pwd, completion: { (user, error) in
                if error != nil {
                    print(error)
                    if error!.code == STATUS_ACCOUNT_NOEXIST {
                        FIRAuth.auth()?.createUserWithEmail(email, password: pwd, completion: { user, error in
                            
                        if error != nil {
                            self.showErrorAlert("Could not create account", msg: "Problem creating account. Try something else")
                        } else {
                            NSUserDefaults.standardUserDefaults().setValue(user!.uid, forKey: KEY_UID)
                            
                            //Store what type of account this is
                            let userData = ["provider": "email"]
                            DataService.ds.createFirebaseUser(user!.uid, user: userData)
                            DataService.ds.REF_USERS.child(user!.uid).child("userName").setValue(userNam)
                            self.uploadPhoto()
                            
                            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                            }
                        })
                    } else {
                        self.showErrorAlert("Error loggin in", msg: "Could not log in. Check your username and password")
                    }
                } else {
                    NSUserDefaults.standardUserDefaults().setValue(user!.uid, forKey: KEY_UID)
                    self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                }
            })
        } else {
            showErrorAlert("Email & Password Required", msg: "You must enter an email address and a password")
        }
    }
   func uploadPhoto() {
    if imageSelect.image == nil {
        imageSelect.image = UIImage(named: "atabaque")
    } else {
    let imageNa = NSUUID().UUIDString
        let storageR = FIRStorage.storage().reference().child("user").child("\(imageNa).jpg")
        if let uploadData = UIImageJPEGRepresentation(self.imageSelect.image!, 0.2) {
            storageR.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                self.metaD = metadata
                if error != nil {
                    print(error)
                    return
                }
                if let profileImageUrl = self.metaD?.downloadURL()?.absoluteString {
                    DataService.ds.REF_USER_CURRENT.child("userImgUrl").setValue(profileImageUrl)
                    self.userPhotoUrl = profileImageUrl
                }
            })
        }
    }
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo editingInfo: [String : AnyObject]) {
       
        var selectedImageFromPicker: UIImage?
        if let editedImage = editingInfo["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = editingInfo["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker {
            imageSelect.image = selectedImage
        }
        //imagePath = saveImageAndCreatePath(imageSelect.image!)
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func selectPhoto(sender: UITapGestureRecognizer) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    func showErrorAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    func dismissKeyboard(notification: NSNotification) {
        view.endEditing(true)
    }
    func keyboardWillShow(notification: NSNotification) {
        //self.view.frame.origin.y -= 260
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y ==  200  {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
}




