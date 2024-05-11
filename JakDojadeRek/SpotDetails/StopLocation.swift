//
//  StopLocation.swift
//  JakDojadeRek
//
//  Created by Mikolaj Zawada on 11/05/2024.
//

import Foundation
import MapKit

class StopLocation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var availableVehicles: String
    
    static let reuseIdentifier = "bikeAnnotation"
    
    init(coordinate: CLLocationCoordinate2D, availableVehicles: Int) {
        self.coordinate = coordinate
        self.availableVehicles = String(availableVehicles)
        super.init()
    }
}
