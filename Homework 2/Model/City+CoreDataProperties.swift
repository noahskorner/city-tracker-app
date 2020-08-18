//
//  City+CoreDataProperties.swift
//  Homework 2
//
//  Created by Noah Korner on 4/6/20.
//  Copyright © 2020 asu. All rights reserved.
//
//

import Foundation
import CoreData


extension City {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City")
    }

    @NSManaged public var cityName: String?
    @NSManaged public var cityDesc: String?
    @NSManaged public var cityImage: Data?

}
