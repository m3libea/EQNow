//
//  eqSortDistanceViewController.swift
//  EQNow
//
//  Created by m3libea on 7/5/15.
//  Copyright (c) 2015 ccsf. All rights reserved.
//

import UIKit
import MapKit


class eqSortDistanceViewController: UITableViewController, LocationPickerViewControllerDelegate {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        USGS.sharedInstance().earthquakes = []
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: "search")
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func search(){
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("Picker") as! eqLocationPickerController
        controller.delegate = self
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    func locationPicker(locationPicker: eqLocationPickerController, didPickLocation mapItem: MKMapItem?) {
        if let mapItem = mapItem {
            let coordinates = mapItem.placemark.coordinate
            USGS.sharedInstance().queryToAPI(["starttime" : USGS.sharedInstance().getDate(), "latitude" : "\(coordinates.latitude)","longitude" : "\(coordinates.longitude)", "maxradiuskm":"100"]){ result, error in
                if let error = error {
                    println(error)
                } else {
                    println("Waiting for data")
                    let data = result["features"] as! [[String: AnyObject]]
                    USGS.sharedInstance().earthquakes = data.map(){Earthquake(dictionary: $0, location: CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude))}
                    dispatch_async(dispatch_get_main_queue()) {
                        println("Data Loading")
                        USGS.sharedInstance().earthquakes.sort({$0.distanceTo < $1.distanceTo})
                        self.tableView.reloadData()
                    }
                }
            }

        
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return USGS.sharedInstance().earthquakes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! eqDistanceTableViewCell
        
        let quake = USGS.sharedInstance().earthquakes[indexPath.row]
        
        cell.place.text = quake.place
        cell.magnitude.text = "\(quake.magnitude)"
        cell.magnitude.textColor = quake.getColorMag()
        cell.date.text = quake.dateToString()
        cell.distance.text = "\(quake.distanceTo)km"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("eqMapViewController") as! eqMapViewController
        let quake = USGS.sharedInstance().earthquakes[indexPath.row]
        
        controller.center = quake.coordinates
        controller.note = quake.annotation
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
}

