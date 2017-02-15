//
//  ViewController.swift
//  NextStopAlarm
//
//  Created by Bradley Nordstrom on 2/8/17.
//  Copyright © 2017 Bradley Nordstrom. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    var alarm: [Alarm]?
    let locationManager = CLLocationManager()
    
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
    
    @IBAction func alarmIsOn(_ sender: Any) {
    }
    
    @IBAction func info(_ sender: Any) {
    }
    
    func region(withLocationKey alarm: Alarm) -> CLCircularRegion {
        let region = CLCircularRegion(center: alarm.coordinate, radius: alarm.radius, identifier: alarm.identifier)
        region.notifyOnEntry = true
        region.notifyOnExit = false
        
        return region
    }
    
    func startMonitoring(alarm: Alarm) {
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            showAlert(withTitle:"Error", message: "NextStop is not supported on this device!")
            return
        }
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            showAlert(withTitle:"Warning", message: "Your NextStop Alarm is saved but will only be activated once you grant NextStop permission to access the device location.")
        }
        
        let region = self.region(withLocationKey: alarm)
        locationManager.startMonitoring(for: region)
    }
    
    func stopMonitoring(alarm: Alarm) {
        for region in locationManager.monitoredRegions {
            guard let circularRegion = region as? CLCircularRegion, circularRegion.identifier == alarm.identifier else { continue }
            locationManager.stopMonitoring(for: circularRegion)
        }
    }
    
    func updateAlarm(){
        if(alarm?.count == 1){
            title = "NextStop (Alarm Set)"
        }
        else {
            title = "NextStop (Alarm Not Set)"
        }
    }
    
}

