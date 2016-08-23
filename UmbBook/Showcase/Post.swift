//
//  Post.swift
//  Showcase
//
//  Created by Alberto Hirota on 8/20/16.
//  Copyright © 2016 Alberto Hirota. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class Post {
    private var _postDescription: String?
    private var _imageUrl: String?
    private var _likes: Int!
    private var _username: String!
    private var _postKey: String!
    private var _postRef: FIRDatabaseReference!
    
    var postDescription: String? {
        return _postDescription
    }
    var imageUrl: String? {
        return _imageUrl
    }
    var likes: Int {
        return _likes
    }
    var username: String {
        return _username
    }
    var postKey: String {
        return _postKey
    }
    init(description: String?, imageUrl: String?, username: String) {
        self._postDescription = description
        self._imageUrl = imageUrl
        self._username = username
    }
    init(postKey: String, dictionary: Dictionary<String, AnyObject>) {
        self._postKey = postKey
        
        if let likes = dictionary["likes"] as? Int {
            self._likes = likes
        }
        if let imgUrl = dictionary["imageUrl"] as? String {
            self._imageUrl = imgUrl
        }
        if let desc = dictionary["description"] as? String {
            self._postDescription = desc
        }
        self._postRef = DataService.ds.REF_POSTS.child(self._postKey)
    }
    func adjustLikes(addLike: Bool) {
        
        if addLike {
            _likes = _likes + 1
        } else {
            _likes = _likes - 1
        }
        //Save the new total likes to firebase
        //_postRef.childByAppendingPath("likes").setValue(_likes)
        _postRef.child("likes").setValue(_likes)
    }
    func updateImagePost(imgUrl: String) {
        _postRef.child("imageUrl").setValue(imgUrl)
    }
}
