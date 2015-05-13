//
//  eqMapViewController.swift
//  EQNow
//
//  Created by m3libea on 8/5/15.
//  Copyright (c) 2015 ccsf. All rights reserved.
//

import UIKit
import MapKit

class eqMapViewController: UIViewController, MKMapViewDelegate {
    
    
    @IBOutlet weak var map: MKMapView!
    var center = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var note: MKPointAnnotation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let center = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        let span = MKCoordinateSpanMake(10, 10)
        map.setRegion(MKCoordinateRegion(center: center, span: span), animated: false)
    }
    
    override func viewWillAppear(animated: Bool) {
        map.setCenterCoordinate(center, animated: false)
        map.addAnnotation(note)
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        var pinView: MKPinAnnotationView = MKPinAnnotationView()
        pinView.annotation = annotation
        pinView.pinColor = MKPinAnnotationColor.Green
        
        return pinView
    }
}
