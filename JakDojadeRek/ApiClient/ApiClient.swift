//
//  ApiClient.swift
//  JakDojadeRek
//
//  Created by Mikolaj Zawada on 10/05/2024.
//

import Foundation
import CoreLocation

final class ApiClient {
    private let networkService: NetworkService
    let locationService: LocationService
    
    init(networkService: NetworkService = NetworkSession(), locationService: LocationService = LocationManager()) {
        self.networkService = networkService
        self.locationService = locationService
    }
    
    func fetchStationsInfo() async throws -> [Station] {
        await locationService.requestAuthorization()
        let currentLocation = try? await locationService.requestCurrentLocation()
        
        let stationsStatus: StationsStatus = try await networkService.fetchData(from:"https://gbfs.urbansharing.com/rowermevo.pl/station_information.json")
        let stationsAvailibility: StationAvailibilityStatus = try await networkService.fetchData(from: "https://gbfs.urbansharing.com/rowermevo.pl/station_status.json")
        
        return zip(stationsStatus.data.stations, stationsAvailibility.data.stations).map { (status, availibility) in
            let stationLocation = CLLocation(latitude: status.lat, longitude: status.lon)
            return Station(
                name: status.name,
                address: status.address,
                location: stationLocation.coordinate,
                id: status.stationID,
                availablePlaces: availibility.numDocksAvailable,
                availableVehicles: availibility.numVehiclesAvailable,
                distance: currentLocation != nil ? Int(currentLocation!.distance(from: stationLocation)) : nil
            )
        }.sorted(by: {
            guard let dis1 = $0.distance, let dis2 = $1.distance else { return false }
            return dis1 < dis2
        })
    }
}
