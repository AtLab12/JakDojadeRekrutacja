//
//  LocationService.swift
//  JakDojadeRek
//
//  Created by Mikolaj Zawada on 11/05/2024.
//

import Foundation
import CoreLocation

protocol LocationService {
    func requestAuthorization() async
    func requestCurrentLocation() async throws -> CLLocation
}
