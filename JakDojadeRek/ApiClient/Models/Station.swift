//
//  Station.swift
//  JakDojadeRek
//
//  Created by Mikolaj Zawada on 10/05/2024.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && rhs.longitude == lhs.longitude
    }
}

struct Station: Equatable, Identifiable {
    let name: String
    let address: String
    let location: CLLocationCoordinate2D
    let id: String
    let availablePlaces: Int
    let availableVehicles: Int
    let distance: Int?
    
    var distanceInMeters: String {
        guard let distance else { return "" }
        return "\(distance)  m  • "
    }
}
