//
//  eqMapViewController.swift
//  EQNow
//
//  Created by m3libea on 8/5/15.
//  Copyright (c) 2015 ccsf. All rights reserved.
//

import UIKit
import MapKit
import Social

class eqMapViewController: UIViewController, MKMapViewDelegate {
    
    
    @IBOutlet weak var map: MKMapView!
    var center = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var note: MKPointAnnotation!
    var place: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var btnFB = UIBarButtonItem(image: UIImage(named: "fb.png"), style: UIBarButtonItemStyle.Plain, target: self, action: "sendFB")
        var btnTW = UIBarButtonItem(image: UIImage(named: "twitter.png"), style: UIBarButtonItemStyle.Plain, target: self, action: "sendTW")
        self.navigationItem.setRightBarButtonItems([btnFB, btnTW], animated: false)

        
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
    
    func sendFB(){
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
            var fbMsg: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            fbMsg.setInitialText("Earthquake located at \(place). I'm...")
            self.presentViewController(fbMsg, animated: true, completion: nil)
        } else {
            var alert = UIAlertController(title: "Account", message: "Login to a FB account to share", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func sendTW(){
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter){
            var twitterMsg: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twitterMsg.setInitialText("Earthquake located at \(place). I'm...")
            self.presentViewController(twitterMsg, animated: true, completion: nil)
        } else {
            var alert = UIAlertController(title: "Account", message: "Login to a Twitter account to share", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
}
