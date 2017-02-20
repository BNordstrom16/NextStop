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
    static let identifier = "identifier"
}


class Alarm: NSObject, NSCoding, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var radius: CLLocationDistance = 40.0
    var identifier: String
    //var mediaPlayer: MPMediaItem
    
    init(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance, identifier: String){
        self.coordinate = coordinate
        self.radius = radius
        self.identifier = identifier
    }
    
    // MARK: NSCoding
    required init?(coder decoder: NSCoder) {
        let latitude = decoder.decodeDouble(forKey: LocationKey.latitude)
        let longitude = decoder.decodeDouble(forKey: LocationKey.longitude)
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        radius = decoder.decodeDouble(forKey: LocationKey.radius)
        identifier = decoder.decodeObject(forKey: LocationKey.identifier) as! String
        //Add media item
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(coordinate.latitude, forKey: LocationKey.latitude)
        coder.encode(coordinate.longitude, forKey: LocationKey.longitude)
        coder.encode(radius, forKey: LocationKey.radius)
        coder.encode(identifier, forKey: LocationKey.identifier)
        //Add media item
    }
    
}
