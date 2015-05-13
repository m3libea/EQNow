//
//  eqSortMagnitudeViewController.swift
//  EQNow
//
//  Created by m3libea on 7/5/15.
//  Copyright (c) 2015 ccsf. All rights reserved.
//

import UIKit

class eqSortMagnitudeViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "loadTable")
    }
    
    override func viewWillAppear(animated: Bool) {
        loadTable()
    }
    
    func loadTable(){
        USGS.sharedInstance().queryToAPI(["starttime" : USGS.sharedInstance().getDate(), "orderby" : "magnitude"]){ result, error in
            if let error = error {
                println(error)
            } else {
                let data = result["features"] as! [[String: AnyObject]]
                USGS.sharedInstance().earthquakes = data.map(){Earthquake(dictionary: $0)}
                dispatch_async(dispatch_get_main_queue()) {
                    println("Data Loading")
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return USGS.sharedInstance().earthquakes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! eqMagnitudeTableViewCell
        
        let quake = USGS.sharedInstance().earthquakes[indexPath.row]
        
        cell.place.text = quake.place
        cell.magnitude.text = "\(quake.magnitude)"
        cell.magnitude.textColor = quake.getColorMag()
        cell.date.text = quake.dateToString()
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("eqMapViewController") as! eqMapViewController
        let quake = USGS.sharedInstance().earthquakes[indexPath.row]
        
        controller.center = quake.coordinates
        controller.note = quake.annotation
        controller.place = quake.place
        self.navigationController!.pushViewController(controller, animated: true)
    }

}
