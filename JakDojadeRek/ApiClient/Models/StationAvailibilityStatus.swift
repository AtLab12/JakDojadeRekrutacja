//
//  AvailabilityStatus.swift
//  JakDojadeRek
//
//  Created by Mikolaj Zawada on 10/05/2024.
//

import Foundation

struct StationAvailibilityStatus: Decodable {
    let data: DataClass

    enum CodingKeys: String, CodingKey {
        case data
    }
}

struct DataClass: Decodable {
    let stations: [StationAvailibility]
}

struct StationAvailibility: Decodable {
    let stationID: String
    let isInstalled, isRenting, isReturning: Bool
    let lastReported, numVehiclesAvailable, numBikesAvailable, numDocksAvailable: Int

    enum CodingKeys: String, CodingKey {
        case stationID = "station_id"
        case isInstalled = "is_installed"
        case isRenting = "is_renting"
        case isReturning = "is_returning"
        case lastReported = "last_reported"
        case numVehiclesAvailable = "num_vehicles_available"
        case numBikesAvailable = "num_bikes_available"
        case numDocksAvailable = "num_docks_available"
    }
}
