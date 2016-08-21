//
//  DataService.swift
//  Showcase
//
//  Created by Alberto Hirota on 8/17/16.
//  Copyright © 2016 Alberto Hirota. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase

let URL_BASE = FIRDatabase.database().reference()

class DataService {
    static let ds = DataService()
    
    
    //base reference that will be using for logging, accessing, authenticate
    var _REF_BASE = URL_BASE

    var _REF_POSTS =  URL_BASE.child("posts")
    var _REF_USERS = URL_BASE.child("users")
    
    //var REF_BASE: Firebase { //old way
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    
    func createFirebaseUser(uid: String, user: Dictionary<String, String>) {
        REF_USERS.child(uid).setValue(user) // this was wrong, this will always try to create new user
        REF_USERS.child(uid).updateChildValues(user)
    }
    
    var REF_USER_CURRENT: FIRDatabaseReference {
        let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String
        let user = URL_BASE.child("users").child(uid)
        return user
    }

    
    
}

