//
//  UserUpdateVC.swift
//  Showcase
//
//  Created by Alberto Hirota on 8/23/16.
//  Copyright © 2016 Alberto Hirota. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class UserUpdateVC: UIViewController {

    @IBOutlet weak var emailField: MaterialTextField!
    @IBOutlet weak var pwdField: MaterialTextField!
    @IBOutlet weak var nameField: MaterialTextField!
    @IBOutlet weak var userImg: UIImageView!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    @IBAction func updateBtn(sender: AnyObject) {
    }
    
    
    @IBAction func logoutBtn(sender: AnyObject) {
        self.handleLogout()
    }
    @IBAction func closeAcBtn(sender: AnyObject) {
        let warningAlert = UIAlertController(title: "Alert", message: "Your account will be deleted!", preferredStyle: UIAlertControllerStyle.Alert)
        
        warningAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler : { (action: UIAlertAction!) in
            
            let user = FIRAuth.auth()?.currentUser
                    user?.deleteWithCompletion({ error in
                        if let error = error {
                            print(error)
                        } else {
                                if error != nil {
                                    print("Failed to delete message: ", error)
                                    return
                                }
                                print("Delete account successfull")
                                self.handleLogout()
                            self.performSegueWithIdentifier(SEGUE_DELETE_AC, sender: nil)
                        }
                    })
                }))
                warningAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
                    print("Account not cancelled")
                }))
                self.presentViewController(warningAlert, animated: true, completion: nil)
    }
    func handleLogout() {
        do{
            //NSUserDefaults.standardUserDefaults().removeObjectForKey("")
            NSUserDefaults.standardUserDefaults().removeObjectForKey(KEY_UID)
            try FIRAuth.auth()!.signOut()
            
        } catch let logoutError {
            print(logoutError)
        }
    }
    func dismissKeyboard(notification: NSNotification) {
        view.endEditing(true)
    }
    func keyboardWillShow(notification: NSNotification) {
        //self.view.frame.origin.y -= 260
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y ==  0 {
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
