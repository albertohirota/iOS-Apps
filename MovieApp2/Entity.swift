//
//  Entity.swift
//  MovieApp2
//
//  Created by Alberto Hirota on 8/14/16.
//  Copyright © 2016 Alberto Hirota. All rights reserved.
//




import Foundation
import CoreData
import UIKit

class Entity: NSManagedObject {
    func setMoviesImg(img: UIImage) {
        let data = UIImagePNGRepresentation(img)
        self.image = data
    }
    
    func getMovieImg() -> UIImage {
        let img = UIImage(data: self.image!)!
        return img
    }
    
//    //private var _image: UIImageView!
//    private var _title: String = ""
//    private var _description: String = ""
//    private var _urlImdb: String = ""
//    private var _urlImdbPlot: String = ""
//    
//    //    var imageM: UIImageView {
//    //        return _image
//    //    }
//    var titleM: String {
//        return _title
//    }
//    var descriptionM: String {
//        return _description
//    }
//    var urlImdbM: String {
//        return _urlImdb
//    }
//    var urlImdbPlotM: String {
//        return _urlImdbPlot
//    }
//    init(titleM: String, descriptionM: String, urlImdbM: String, urlImdbPlotM: String){
//        // self._image = imageM
//        self._title = titleM
//        self._description = descriptionM
//        self._urlImdb = urlImdbM
//        self._urlImdbPlot = urlImdbPlotM
//    }

    
}