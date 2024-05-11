//
//  LocationManager.swift
//  JakDojadeRek
//
//  Created by Mikolaj Zawada on 10/05/2024.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate, LocationService {
    
    private let manager: CLLocationManager
    
    private var currentLocationContinuation: CheckedContinuation<CLLocation, Error>? = nil
    private var authStatusContinuation: CheckedContinuation<Void, Never>? = nil
    
    public override init() {
        self.manager = CLLocationManager()
        super.init()
        self.manager.delegate = self
    }
    
    func requestCurrentLocation() async throws -> CLLocation {
        return try await withCheckedThrowingContinuation { [weak self] (continuation: CheckedContinuation<CLLocation, Error>) in
            guard let self = self else { return }
            self.currentLocationContinuation = continuation
            self.manager.desiredAccuracy = kCLLocationAccuracyBest
            self.manager.requestLocation()
        }
    }
    
    func requestAuthorization() async {
        return await withCheckedContinuation { [weak self] (continuation: CheckedContinuation<Void, Never>) in
            guard let self = self else { return }
            self.authStatusContinuation = continuation
            self.manager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLocationContinuation?.resume(with: .success(location))
            currentLocationContinuation = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        currentLocationContinuation?.resume(throwing: error)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authStatusContinuation?.resume()
        authStatusContinuation = nil
    }
}
