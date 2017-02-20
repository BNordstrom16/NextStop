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

struct PreferencesKeys {
    static let savedItems = "savedItems"
}

class ViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var cancelAlarm: UIBarButtonItem!
    @IBOutlet weak var setAlarm: UIBarButtonItem!
    
    var alarm: Alarm?
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation = true
        locationManager.requestAlwaysAuthorization()
        cancelAlarm.isEnabled = false
        setAlarm.isEnabled = true
        loadAlarm()
    }
    
    func addAlarm(controller: ViewController, didAddCoordinate coordinate: CLLocationCoordinate2D, radius: Double, identifier: String){
        controller.dismiss(animated: true, completion: nil)
        let clampedRadius = min(radius, locationManager.maximumRegionMonitoringDistance)
        let alarm = Alarm(coordinate: coordinate, radius: clampedRadius, identifier: identifier)
        add(oneAlarm: alarm)
        startMonitoring(alarm: alarm)
        saveAlarm()
        updateAlarm()
    }

    
    func loadAlarm() {
        guard let savedItem = UserDefaults.standard.data(forKey: PreferencesKeys.savedItems) else { return }
        guard let alarm = NSKeyedUnarchiver.unarchiveObject(with: savedItem) as? Alarm else { return }
        add(oneAlarm: alarm)
        updateAlarm()
    }
    
    func saveAlarm() {
        if(alarm != nil) {
            let item = NSKeyedArchiver.archivedData(withRootObject: alarm!)
            UserDefaults.standard.set(item, forKey: PreferencesKeys.savedItems)
        }
    }
    
    @IBAction func cancelAlarm(_ sender: Any) {
        remove(oneAlarm: alarm!)
    }
    
    func remove(oneAlarm: Alarm) {
        cancelAlarm.isEnabled = false
        setAlarm.isEnabled = true
        mapView.removeAnnotation(oneAlarm)
        removeRadiusOverlay(forAlarm: oneAlarm)
        alarm = nil
        updateAlarm()
    }
    
    func removeRadiusOverlay(forAlarm alarm: Alarm) {
        // Find exactly one overlay which has the same coordinates & radius to remove
        guard let overlays = mapView?.overlays else { return }
        for overlay in overlays {
            guard let circleOverlay = overlay as? MKCircle else { continue }
            let coord = circleOverlay.coordinate
            if coord.latitude == alarm.coordinate.latitude && coord.longitude == alarm.coordinate.longitude && circleOverlay.radius == alarm.radius {
                mapView?.remove(circleOverlay)
                break
            }
        }
    }
    
    func add(oneAlarm: Alarm) {
        if(alarm != nil){
            remove(oneAlarm: alarm!)
        }
        cancelAlarm.isEnabled = true
        setAlarm.isEnabled = false
        alarm = oneAlarm
        mapView.addAnnotation(alarm!)
        addRadiusOverlay(forAlarm: alarm!)
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
        let coordinate = mapView.centerCoordinate
        let radius = 40.0
        let identifier = NSUUID().uuidString
        addAlarm(controller: self, didAddCoordinate: coordinate, radius: radius, identifier: identifier)
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
    
    // MARK: Map overlay functions
    func addRadiusOverlay(forAlarm alarm: Alarm) {
        mapView?.add(MKCircle(center: alarm.coordinate, radius: alarm.radius))
    }
    
    func updateAlarm(){
        if(alarm != nil){
            title = "NextStop (Alarm Set)"
        }
        else {
            title = "NextStop (Alarm Not Set)"
        }
    }
    
}

// MARK: - Location Manager Delegate
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        mapView.showsUserLocation = (status == .authorizedAlways)
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Monitoring failed for region with identifier: \(region!.identifier)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager failed with the following error: \(error)")
    }
}

extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // Delete geotification
        let alarm = view.annotation as! Alarm
        stopMonitoring(alarm: alarm)
        remove(oneAlarm: alarm)
        saveAlarm()
    }
    
    
}


