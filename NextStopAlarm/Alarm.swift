//
//  Alarm.swift
//  NextStopAlarm
//
//  Created by Bradley Nordstrom on 2/9/17.
//  Copyright © 2017 Bradley Nordstrom. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import MediaPlayer

struct LocationKey{
    static let latitude = "latitude"
    static let longitude = "longitude"
    static let radius = "radius"
    
}


class Alarm: NSObject, NSCoding {
    
    var title: String
    var coordinate: CLLocationCoordinate2D
    var radius: CLLocationDistance
    //var mediaPlayer: MPMediaItem
    
    init(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance, media: MPMediaItem){
        title = "Alarm"
        self.coordinate = coordinate
        self.radius = radius
    }
    
    required init?(coder decoder: NSCoder) {
        title = "Alarm"
        let latitude = decoder.decodeDouble(forKey: LocationKey.latitude)
        let longitude = decoder.decodeDouble(forKey: LocationKey.longitude)
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        radius = decoder.decodeDouble(forKey: LocationKey.radius)
        //Add media item
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(coordinate.latitude, forKey: LocationKey.latitude)
        coder.encode(coordinate.longitude, forKey: LocationKey.longitude)
        coder.encode(radius, forKey: LocationKey.radius)
        //Add media item
    }
    
}
