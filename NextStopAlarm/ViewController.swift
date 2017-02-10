//
//  ViewController.swift
//  NextStopAlarm
//
//  Created by Bradley Nordstrom on 2/8/17.
//  Copyright © 2017 Bradley Nordstrom. All rights reserved.
//

import UIKit
import MapKit
class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func userLocation(_ sender: Any) {
        let userLocation = mapView.userLocation
        let region = MKCoordinateRegionMakeWithDistance(userLocation.location!.coordinate, 2000, 2000)
        
        mapView.setRegion(region, animated: true)
    }

    @IBAction func setAlarm(_ sender: Any) {
    }
    
    @IBAction func info(_ sender: Any) {
    }
}

