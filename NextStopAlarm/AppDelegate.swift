//
//  AppDelegate.swift
//  NextStopAlarm
//
//  Created by Bradley Nordstrom on 2/8/17.
//  Copyright © 2017 Bradley Nordstrom. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    let locationManager = CLLocationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let center = UNUserNotificationCenter.current()
        
        center.delegate = self
        center.requestAuthorization(options: [.sound,.alert,.badge]) { (granted, error) in
            if(granted){
                print("Notifications allowed")
            }
            else{
                print("Notifications not allowed")
            }
        }
        application.registerForRemoteNotifications()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        center.removeAllPendingNotificationRequests()
        return true
    }
    
    func handleEvent(forRegion region: CLRegion!) {
        let center = UNUserNotificationCenter.current()
        
        // Show an alert if application is active
        if UIApplication.shared.applicationState == .active {
            window?.rootViewController?.showAlert(withTitle: nil, message: "Your stop has been reached.")
        } else {
            // Otherwise present a local notification
            let notification = UNMutableNotificationContent()
            notification.title = "Next Stop!"
            notification.body = "Your stop has been reached."
            notification.sound = UNNotificationSound.default()
            
            let trigger = UNLocationNotificationTrigger(region: region, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: notification, trigger: trigger)
            
            center.add(request)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            handleEvent(forRegion: region)
        }
    }

}

