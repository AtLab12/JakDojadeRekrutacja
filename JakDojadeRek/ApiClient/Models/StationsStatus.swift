//
//  StationStatus.swift
//  JakDojadeRek
//
//  Created by Mikolaj Zawada on 10/05/2024.
//

import Foundation

struct StationsStatus: Decodable {
    let data: StationsData

    enum CodingKeys: String, CodingKey {
        case data
    }
}

struct StationsData: Decodable {
    let stations: [StationData]
}

struct StationData: Decodable {
    let stationID, name, address: String
    let lat, lon: Double
    let capacity: Int

    enum CodingKeys: String, CodingKey {
        case stationID = "station_id"
        case name, address
        case lat, lon
        case capacity
    }
}
