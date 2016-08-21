//
//  PersonCell.swift
//  MissingPersons
//
//  Created by Alberto Hirota on 8/12/16.
//  Copyright © 2016 Alberto Hirota. All rights reserved.
//
import UIKit

class PersonCell: UICollectionViewCell {
    
    @IBOutlet weak var personImage: UIImageView!
    var person: Person!
    
    func configureCell(person: Person) {
        self.person = person
        if let url = NSURL(string: "\(baseURL)\(person.personImageUrl!)") {
            downloadImage(url)
        }
    }
    func downloadImage(url: NSURL) {
        getDataFromUrl(url) { (data, response, error) in // to not use the main thread
            dispatch_async(dispatch_get_main_queue()) { () -> Void in //now here it says to bring the images from background thread to main thread
                guard let data1 = data where error == nil else { return } // that means, if there is data and no error, otherwise, it will not do anythign,
                self.personImage.image = UIImage(data: data1)
                self.person.personImage = self.personImage.image
               // self.person.downloadFaceId() // he doesn't want to keeping detecting Face IDs
                //self.person.faceId = Person.faceId
                
            }
        }
    }
    func setSelected() {
        personImage.layer.borderWidth = 2.0
        personImage.layer.borderColor = UIColor.yellowColor().CGColor
        self.person.downloadFaceId()
    }
    func setUnselected() {
        personImage.layer.borderColor = UIColor.whiteColor().CGColor
//        self.person.downloadFaceId()
    }
    func getDataFromUrl(url: NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError?) -> Void)) {
        
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in //when it is done, it passes this datas
            completion(data: data, response: response, error: error) //forward data
        } .resume() //we need to call .resume to start your NSURLSession data
        // the reason to do all this, instead of download the image straight to the image and have some glitches and pause when it is running in the main thread
        // we want to go in the background thread, when it is finished go to the main thread and upload the images
    }
}
