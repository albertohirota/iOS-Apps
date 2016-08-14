//
//  Entity+CoreDataProperties.swift
//  MovieApp2
//
//  Created by Alberto Hirota on 8/14/16.
//  Copyright © 2016 Alberto Hirota. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Entity {

    @NSManaged var descriptionMovie: String?
    @NSManaged var image: NSData?
    @NSManaged var title: String?
    @NSManaged var urlImdb: String?
    @NSManaged var urlImdbPlot: String?

}
