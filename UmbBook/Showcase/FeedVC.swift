//
//  FeedVC.swift
//  Showcase
//
//  Created by Alberto Hirota on 8/18/16.
//  Copyright © 2016 Alberto Hirota. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import Alamofire


class FeedVC: UIViewController, UITableViewDataSource, UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    static let imageCache = NSCache()
    static let userImgCache = NSCache()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var postField: MaterialTextField!
    var posts = [Post]()
    var users = [Post]()
    var imagePicker: UIImagePickerController!
    var metaD: FIRStorageMetadata?
    var userId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 407
        postImg.layer.cornerRadius = 2.0
        postImg.clipsToBounds = true
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        initObservers()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(FeedVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    func initObservers() {
        
        DataService.ds.REF_POSTS.observeEventType(.Value, withBlock: { snapshot in
            self.posts = []
            //if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {//old way
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshots {
                    print("SNAP:\(snap)")
                    //Clear the array because we are going to add all the objects again
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, dictionary: postDict)
                        self.posts.append(post)
                    }
                }
                }
                self.tableView.reloadData()
        })
        DataService.ds.REF_USERS.observeEventType(.Value, withBlock: { snapshot in
            self.users = []
            //if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {//old way
            if let snapshotsU = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshotsU {
                    print("SNAPUSER:\(snap)")
                    //Clear the array because we are going to add all the objects again
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        self.userId = key
                        let user = Post(postKey: key, dictionary: postDict)
                        self.users.append(user)
                        let userProfile = FIRAuth.auth()?.currentUser
                        let userUid = userProfile?.uid
                            if let uName = postDict["userName"] as? String where key == userUid {
                                let userNa = "\(uName)"
                                print("YYYYYY: \(userNa)")
                                    let changeRequest = userProfile!.profileChangeRequest()
                                    changeRequest.displayName = userNa
                                
                                    changeRequest.commitChangesWithCompletion({ error in
                                    if let error = error {
                                        print(error)
                                    } else {
                                        print("Profile updated")
                                    }
                                    })
                            }
                            if let uImgU = postDict["userImgUrl"] as? String where key == userUid {
                                let userImgUrl1 = "\(uImgU)"
                                print(userImgUrl1)
                                let changeRequest = userProfile!.profileChangeRequest()
                                changeRequest.photoURL = NSURL(string: userImgUrl1 )
                                changeRequest.commitChangesWithCompletion({ error in
                                    if let error = error {
                                        print(error)
                                    } else {
                                        print("Profile updated")
                                        /*if let userProfile = FIRAuth.auth()?.currentUser {
                                            let namexxx = userProfile.displayName
                                            let emailxxx = userProfile.email
                                            let imageUrlxxx = userProfile.photoURL
                                            self.userId = userProfile.uid
                                            print("XXXX \(namexxx)")
                                            print("XXXX \(emailxxx)")
                                            print("XXXX \(imageUrlxxx)")
                                            print("XXXX \(self.userId)")
                                        }*/
                                    }
                                })
                            }
                    }
                }
            }
        })
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as? PostCell {
            //Cancel the image request when cellForRowAtIndexPath is called because it means
            //we need to recycle the cell and we need the old request to stop downloading the image
            cell.request?.cancel()
            let post = self.posts[indexPath.row]
            //Declare an empty image variable
            var img: UIImage?
            //If there is a url for an image, try and get it from the local cache first
            //before we attempt to download it
            if let url = post.imageUrl {
                img = FeedVC.imageCache.objectForKey(url) as? UIImage //this FeedVC, it is almost like self
            }
            var userPhoto: UIImage?
            let userProfile = FIRAuth.auth()?.currentUser
            let uImageUrl = userProfile?.uid
            if let urlP = uImageUrl {
                userPhoto = FeedVC.userImgCache.objectForKey(urlP) as? UIImage
            }
            
            cell.configureCell(post, img: img, userPhoto: userPhoto)
            return cell
        } else {
            return PostCell()
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let post = posts[indexPath.row]
        if post.imageUrl == nil {
            return 150
        } else {
            return tableView.estimatedRowHeight
        }
    }
    @IBAction func selectPhoto(sender: UITapGestureRecognizer) {
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    @IBAction func makePost(sender: AnyObject) {
        if let txt = postField.text where txt != "" {
            if let img = postImg.image {
           
                let imageName = NSUUID().UUIDString
                let storageR = FIRStorage.storage().reference().child("posts").child("\(imageName).jpg")
                if let uploadData = UIImageJPEGRepresentation(img, 0.2) {
                    storageR.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                        self.metaD = metadata
                        if error != nil {
                            print(error)
                            return
                        }
                        if let imageUrl = self.metaD?.downloadURL()?.absoluteString {
                            self.postToFirebase(imageUrl)
                            print("xxxxxxxx\(imageUrl)")
                        } else {
                            self.postToFirebase(nil)
                        }
                    })
                }
/*              let urlStr = "https://post.imageshack.us/upload_api.php"
                let keyData = "12DJKPSU5fc3afbd01b1630cc718cae3043220f3".dataUsingEncoding(NSUTF8StringEncoding)!
                let keyJSON = "json".dataUsingEncoding(NSUTF8StringEncoding)!
                
                Alamofire.upload(.POST, url, multipartFormData: { multipartFormData in
                    
                    multipartFormData.appendBodyPart(data: imgData, name:"fileupload", fileName:"image", mimeType: "image/jpg")
                    multipartFormData.appendBodyPart(data: keyData, name: "key")
                    multipartFormData.appendBodyPart(data: keyJSON, name: "format")
                }) { encodingResult in
                    
                    switch encodingResult {
                    case .Success(let upload, _, _):
                        upload.responseJSON(completionHandler: { response in
                        //upload.responseJSON(completionHandler: { request, response, result in
                        
                            if let info = response.result.value as? Dictionary<String, AnyObject> {
                              //if let info = result.data as? Dictionary<String, AnyObject> {
                                if let links = info["links"] as? Dictionary<String, AnyObject> {
                                    print(links)
                                    if let imgLink = links["image_link"] as? String {
                                        self.postToFirebase(imgLink)
                                    }
                                }
                            }
                        })
                    case .Failure(let error):
                        print(error)
                        //Maybe show alert to user and let them try again
                    }
                }
            } else {
                postToFirebase(nil)
        */ }
        }
    }
    func postToFirebase(imgUrl: String?) {
        let userProfile = FIRAuth.auth()?.currentUser
        var post: Dictionary<String, AnyObject> = [
            "description":postField.text!,
            "likes": 0,
            "userId":userId!,
            "email":(userProfile?.email)!,
            "userPhotoUrl":(userProfile?.photoURL)!
        ]
        if imgUrl != nil {
            post["imageUrl"] = imgUrl!
        }
        //Save new post to firebase
        let fbPost = DataService.ds.REF_POSTS.childByAutoId()
        fbPost.setValue(post)
        //Clear out fields
        self.postField.text = ""
        self.postImg.image = UIImage(named: "camera")
        tableView.reloadData()
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        postImg.image = image
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
}






