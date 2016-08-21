//
//  Person.swift
//  MissingPersons
//
//  Created by Alberto Hirota on 8/12/16.
//  Copyright © 2016 Alberto Hirota. All rights reserved.
//

import Foundation
import UIKit
import ProjectOxfordFace

class Person {
    var faceId: String?
    var personImage: UIImage?
    var personImageUrl: String?
    
    init (personImageUrl: String) {
        self.personImageUrl = personImageUrl
    }
    
    func downloadFaceId() {
        if let img = personImage, let imgData = UIImageJPEGRepresentation(img, 0.8) { //this command is requiried to check if there is an image, and if positive to convert the image to JPEG
            FaceService.instance.client.detectWithData(imgData, returnFaceId: true, returnFaceLandmarks: false, returnFaceAttributes: nil, completionBlock: {(faces:[MPOFace]!, err:NSError!) in
                if err == nil {
                    var faceId: String?
                    for face in faces {
                        faceId = face.faceId
                        
                        print("Face Id: \(faceId)")
                        break
                    }
                    
                    self.faceId = faceId
                }
            
            })
            
            
            
            
        }
    }
}