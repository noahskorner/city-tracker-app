//
//  Cities.swift
//  Homework 2
//
//  Created by Noah Korner on 4/6/20.
//  Copyright © 2020 asu. All rights reserved.
//
import UIKit
import CoreData

class Cities
{
    var Cities:[cityObject] = []
    
    init(){
    }
    
    func getCount() -> Int{
        return Cities.count
    }
    
    func addCityObject(name:String, desc: String, image: UIImage){
        let newCity = cityObject(cn: name, cd: desc, cimg: image)
        Cities.append(newCity)
    }
    
    func getCityObject(item:Int) -> cityObject{
        return Cities[item]
    }
    
    func getCityObject(findName:String) -> cityObject{
        var foundCity = cityObject(cn: "Temp Name", cd: "Temp Desc", cimg: UIImage(named: "default.jpg")!)
        for city in Cities {
            if city.cityName == findName{
                foundCity = city
            }
        }
        return foundCity
    }
    
}

class cityObject{
    var cityName:String?
    var cityDescription:String?
    var cityImage:UIImage
       
    init(cn:String, cd:String, cimg:UIImage){
        cityName = cn
        cityDescription = cd
        cityImage = cimg
    }
}

