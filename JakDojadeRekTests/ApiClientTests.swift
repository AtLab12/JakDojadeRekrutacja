//
//  ApiClientTests.swift
//  JakDojadeRekTests
//
//  Created by Mikolaj Zawada on 11/05/2024.
//

import XCTest
import MapKit
@testable import JakDojadeRek

extension StationAvailibility {
    static let mock: Self = .init(
        stationID: "mock id",
        isInstalled: true,
        isRenting: false,
        isReturning: false,
        lastReported: 10,
        numVehiclesAvailable: 8,
        numBikesAvailable: 5,
        numDocksAvailable: 10
    )
}

extension StationData {
    static let mock: Self = .init(
        stationID: "mock id",
        name: "mock name",
        address: "mock address",
        lat: 60.0,
        lon: 20.0,
        capacity: 20
    )
}

class MockNetworkService: NetworkService {
    
    enum Errors: Error {
        case unsuportedTestType
    }
    
    func fetchData<T>(from url: String) async throws -> T where T : Decodable {
        if T.self == StationAvailibilityStatus.self {
            return StationAvailibilityStatus(data: .init(stations: [.mock])) as! T
        } else if T.self == StationsStatus.self {
            return StationsStatus(data: .init(stations: [.mock])) as! T
        } else {
            throw Errors.unsuportedTestType
        }
    }
}

class MockLocationService: LocationService {
    func requestAuthorization() async {
        return
    }
    
    func requestCurrentLocation() async throws -> CLLocation {
        CLLocation(latitude: 50.0, longitude: 20.0)
    }
}

final class ApiClientTests: XCTestCase {
    func testFetchStationsInfo() async throws {
        let mockNetworkService = MockNetworkService()
        let mockLocationService = MockLocationService()
        let apiClient = ApiClient(networkService: mockNetworkService, locationService: mockLocationService)
        let expectedStation = Station(
            name: "mock name",
            address: "mock address",
            location: .init(latitude: 60.0, longitude: 20.0),
            id: "mock id",
            availablePlaces: 10,
            availableVehicles: 8,
            distance: 1113225
        )
        
        
        let stations = try await apiClient.fetchStationsInfo()
        XCTAssertEqual(stations.count, 1)
        XCTAssertEqual(stations.first, expectedStation)
    }
}
