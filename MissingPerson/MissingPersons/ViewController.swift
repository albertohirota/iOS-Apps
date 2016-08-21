//
//  ViewController.swift
//  MissingPersons
//
//  Created by Alberto Hirota on 8/12/16.
//  Copyright © 2016 Alberto Hirota. All rights reserved.
//

import UIKit
import ProjectOxfordFace


let baseURL = "https://s3.amazonaws.com/albertodevelopment/MissingPerson/"


class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let missingPeople = [
        Person(personImageUrl: "person1.jpg"),
        Person(personImageUrl: "person2.jpg"),
        Person(personImageUrl: "person3.jpg"),
        Person(personImageUrl: "person4.jpg"),
        Person(personImageUrl: "person5.jpg"),
        Person(personImageUrl: "person6.png"),
        Person(personImageUrl: "person7.jpg"),
        Person(personImageUrl: "person8.jpg")
    ]
    
    var faceIdArray = [String] ()
    
    let imagePicker = UIImagePickerController()
    var selectedPerson: Person?
    var hasSelectedImage: Bool = false
    var matchLevel: NSNumber!
    let match: String = "These images MATCH"
    let notMatch: String = "These images do NOT Match"
    var resultMessage: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        imagePicker.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(loadPicker(_:)))
        tap.numberOfTapsRequired = 1
        selectedImg.addGestureRecognizer(tap)
    }

    @IBOutlet weak var selectedImg: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return missingPeople.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PersonCell", forIndexPath: indexPath) as! PersonCell
        
        let person = missingPeople[indexPath.row]
        //let url = "\(baseURL)\(missingPeople[indexPath.row])"
        cell.configureCell(person)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
            self.selectedPerson = missingPeople[indexPath.row]
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PersonCell
            cell.configureCell(selectedPerson!)
            cell.setSelected()
          }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
       
 //           self.selectedPerson = missingPeople[indexPath.row]
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PersonCell
//            cell.configureCell(selectedPerson!)
            cell.setUnselected()
     
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImg.image = pickedImage
            hasSelectedImage = true
        }
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    func loadPicker(gesture: UITapGestureRecognizer) {
        let alert: UIAlertController=UIAlertController(title: "Picture Option", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Library", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.openGallary()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in self.cancel()
        }
        
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true, completion: nil)

}
    
    func openCamera() {
        if UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            presentViewController(imagePicker, animated: true, completion: nil)

        } else {
            let alertWarning = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: UIAlertControllerStyle.Alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
            alertWarning.addAction(ok)
            self.presentViewController(alertWarning, animated: true, completion: nil)
        }
    }
    
    func openGallary() {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            
            presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func cancel() {
        print("Cancel Clicked")
    }
    
    
    func showErrorAlert() {
        let alert = UIAlertController(title: "Select Person", message: "Please select a missing person to check and an image from your library", preferredStyle: UIAlertControllerStyle.Alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(ok)
         self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func checkMatch(sender: AnyObject) {
        if selectedPerson == nil || !hasSelectedImage {
            showErrorAlert()
           
        } else {
            if let myImg = selectedImg.image, let imgData = UIImageJPEGRepresentation(myImg, 0.8) {
                FaceService.instance.client.detectWithData(imgData, returnFaceId: true, returnFaceLandmarks: false, returnFaceAttributes: nil, completionBlock: { (faces: [MPOFace]!, err: NSError!) in
                    
                    if err == nil {
                        var faceId: String?
                        for face in faces {
                            faceId = face.faceId
                            break
                        }
                        if faceId != nil {
                            FaceService.instance.client.verifyWithFirstFaceId(self.selectedPerson!.faceId, faceId2: faceId, completionBlock: { (result: MPOVerifyResult!, err: NSError!) in
                                if err == nil {
                                print(result.confidence)
                                print(result.isIdentical)
                                print(result.debugDescription)
                                    self.matchLevel = result.confidence
                                   self.matchLevel = Double(self.matchLevel) * 100
                                    if result.isIdentical {
                                        self.resultMessage = self.match
                                    } else {
                                        self.resultMessage = self.notMatch
                                    }
                                } else {
                                    print(err.debugDescription)
                                }
                                self.showResult()
                            })
                        }
                    }
            })
        }
            
    }
  }
    func showResult() {
        let alert = UIAlertController(title: "Results", message: "According to our image algorithm: \(resultMessage). There is a mathematical probability of: \(matchLevel)% to be the same person", preferredStyle: UIAlertControllerStyle.Alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(ok)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    let formattedString = NSMutableAttributedString()
}


