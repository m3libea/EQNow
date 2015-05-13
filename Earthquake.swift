//
//  Earthquake.swift
//  EQNow
//
//  Created by m3libea on 7/5/15.
//  Copyright (c) 2015 ccsf. All rights reserved.
//
import Foundation
import MapKit

class Earthquake {
    var date: NSDate
    var magnitude: Double
    var depth: Double
    var coordinates: CLLocationCoordinate2D
    var place: String
    //Var to make easier to sort the elements in the distance tab
    var distanceTo: CLLocationDistance
    
    init(dictionary: [String : AnyObject]) {
        let properties = dictionary["properties"] as! [String : AnyObject]
        let geo = dictionary["geometry"] as![String : AnyObject]
        let coordinates = geo["coordinates"] as! [Double]
        let timeInterval = properties["time"] as! NSTimeInterval
        depth = coordinates[2]
        place = properties["place"] as! String
        self.coordinates = CLLocationCoordinate2D(latitude: coordinates[1], longitude: coordinates[0])
        date = NSDate(timeIntervalSince1970: timeInterval/1000)
        magnitude = properties["mag"] as! Double
        distanceTo = 0
    }
    
    init(dictionary: [String : AnyObject], location:CLLocation){
        let properties = dictionary["properties"] as! [String : AnyObject]
        let geo = dictionary["geometry"] as![String : AnyObject]
        let coordinates = geo["coordinates"] as! [Double]
        let timeInterval = properties["time"] as! NSTimeInterval
        depth = coordinates[2]
        place = properties["place"] as! String
        self.coordinates = CLLocationCoordinate2D(latitude: coordinates[1], longitude: coordinates[0])
        date = NSDate(timeIntervalSince1970: timeInterval/1000)
        magnitude = properties["mag"] as! Double
        distanceTo = Double(round(100*(location.distanceFromLocation(CLLocation(latitude: self.coordinates.latitude, longitude: self.coordinates.longitude))/1000))/100)
    }
    
    var annotation: MKPointAnnotation {
        let point = MKPointAnnotation()
        point.coordinate = coordinates
        point.subtitle = self.dateToString()
        point.title = "Magnitude: \(magnitude)"
        return point
    }
    
    func dateToString()->String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeZone = NSTimeZone()
        return dateFormatter.stringFromDate(date)
    }
    
    func getHour()-> String{
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute , fromDate: date)
        var minute = ""
        
        if(components.minute <= 9){
            minute = "0\(components.minute)"
        }else{
            minute = "\(components.minute)"
        }
                
        return "\(components.hour):\(minute)"
    }
    
    //Method to get the color for magnitude text
    func getColorMag()-> UIColor{
        if(magnitude < 2){
            return UIColor.yellowColor()
        }else if magnitude < 5{
            return UIColor.orangeColor()
        }else{
            return UIColor.redColor()
        }
    }
}