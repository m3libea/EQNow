//
//  USGS.swift
//  EQNow
//
//  Created by m3libea on 7/5/15.
//  Copyright (c) 2015 ccsf. All rights reserved.
//

import Foundation

class USGS: NSObject {
    
    var session: NSURLSession
    var earthquakes = [Earthquake]()
    typealias CompletionHandler = (result: AnyObject!, error: NSError?) -> Void
    
    
    //Constants
    let baseURL = "http://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&"
    
    override init(){
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    //MARK: API Queries
    
    func queryToAPI(parameters: [String : AnyObject]?, completionHandler: CompletionHandler)->NSURLSessionDataTask{
        var URL = "\(baseURL)"
        var param = [String]()
        
        if let parameters = parameters {
            for(key,value) in parameters {
                param.append("\(key)=\(value)")
            }
        }
        
        if param.count > 0 {
            let p = "&".join(param)
            URL = "\(URL)\(p)"
        }
        
        println(URL)
        
        let request = NSURLRequest(URL: NSURL(string: URL)!)
        
        let task = session.dataTaskWithRequest(request){data, response, downloadError in
            if let error = downloadError {
                completionHandler(result: nil, error: error)
            }else{
                self.parseJSON(data, completionHandler: completionHandler)
            }
        }
        task.resume()
        return task
        
        
    }
    
    //Parse JSON
    
    func parseJSON(data: NSData, completionHandler: CompletionHandler) {
        var parsingError: NSError? = nil
        
        let parsedResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError)
        
        if let error = parsingError {
            completionHandler(result: nil, error: error)
        } else {
            completionHandler(result: parsedResult, error: nil)
        }
    }
    
    
    
    //Auxiliar Methods
    
    func getDate()-> String{
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: date )
        
        return "\(components.year)-\(components.month)-\(components.day)"
    }
    
    class func sharedInstance() -> USGS {
        
        struct Singleton {
            static var sharedInstance = USGS()
        }
        
        return Singleton.sharedInstance
    }
    
}