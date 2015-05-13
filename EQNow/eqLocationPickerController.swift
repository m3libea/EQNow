//
//  eqLocationPickerController.swift
//  EQNow
//
//  Created by m3libea on 11/5/15.
//  Copyright (c) 2015 ccsf. All rights reserved.
//

import Foundation
import MapKit

protocol LocationPickerViewControllerDelegate{
    func locationPicker(locationPicker: eqLocationPickerController, didPickLocation mapItem: MKMapItem?)
}

class eqLocationPickerController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableview: UITableView!
    
    var delegate: LocationPickerViewControllerDelegate?
    var results = [MKMapItem]()
    var region: MKCoordinateRegion?
    var search: MKLocalSearch?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK: Search Bar Delegate
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        //Cancel task
        if let search = search{
            search.cancel()
        }
        
        //If the text is empty, we are done
        if searchText == "" {
            results = [MKMapItem]()
            tableview.reloadData()
            objc_sync_exit(self)
            return
        }
        
        //New Location Search
        
        let request = MKLocalSearchRequest()
        if let region = region {
            request.region = region
        }
        
        request.naturalLanguageQuery = searchText
        search = MKLocalSearch(request: request)
        search!.startWithCompletionHandler { response, error in
            if let error = error{
                println("Error Ocurred in search: \(error.localizedDescription)")
            }else if response.mapItems.count == 0 {
                println("No matches found")
            }else{
                println("Matches found")
                self.results = response.mapItems as! [MKMapItem]
                self.search = nil
                dispatch_async(dispatch_get_main_queue()){
                    self.tableview.reloadData()
                }
            }

        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    @IBAction func cancel(sender: AnyObject) {
        delegate?.locationPicker(self, didPickLocation: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        cell.textLabel?.text = results[indexPath.row].name
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let mapItem = results[indexPath.row]
        delegate?.locationPicker(self, didPickLocation: mapItem)
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}