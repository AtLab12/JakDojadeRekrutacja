//
//  SpotDetailsViewController.swift
//  JakDojadeRek
//
//  Created by Mikolaj Zawada on 11/05/2024.
//

import Foundation
import UIKit
import MapKit

class SpotDetailsViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var detailsStack: UIStackView!
    @IBOutlet weak var distanceAddressStack: UIStackView!
    
    @IBOutlet weak var spotName: UILabel!
    @IBOutlet weak var distanceFromSpot: UILabel!
    @IBOutlet weak var spotAddress: UILabel!
    @IBOutlet weak var availableBikes: UILabel!
    @IBOutlet weak var availableSpaces: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    let mapScale: CGFloat = 300
    
    var station: Station?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: StopLocation.reuseIdentifier)
        detailsStack.setCustomSpacing(18, after: distanceAddressStack)
        detailsStack.backgroundColor = .white
        detailsStack.layer.cornerRadius = 20
        
        // setting custom back button
        let backBTN = UIBarButtonItem(image: UIImage(named: "backButton"),
                                      style: .plain,
                                      target: navigationController,
                                      action: #selector(UINavigationController.popViewController(animated:)))
        navigationItem.leftBarButtonItem = backBTN
        // required to keep the "swipe back" gesture
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        if let station {
            spotName.text = station.name
            distanceFromSpot.text = station.distanceInMeters
            spotAddress.text = station.address
            availableBikes.text = String(station.availableVehicles)
            availableSpaces.text = String(station.availablePlaces)
            
            if station.availableVehicles > 0 {
                availableBikes.textColor = UIColor(named: "BikeGreen")
            } else {
                availableBikes.textColor = .red
            }
            
            mapView.addAnnotation(StopLocation(coordinate: station.location, availableVehicles: station.availableVehicles))
            
            Task {
                do {
                    try await loadRoute(station: station)
                } catch {
                    let alert = UIAlertController(title: "Error", message: "App failed to load route to station", preferredStyle: .alert)
                    alert.addAction(.init(title: "Cancel", style: .cancel, handler: { action in
                        self.navigationController?.popViewController(animated: true)
                    }))
                    alert.addAction(.init(title: "Show just location", style: .default))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    private func loadRoute(station: Station) async throws {
        let locationManager = LocationManager()
        await locationManager.requestAuthorization()
        let userLocation = try await locationManager.requestCurrentLocation()
        
        try await showRouteOnMap(startCoordinate: userLocation.coordinate, destinationCoordinate: station.location)
    }
}

extension SpotDetailsViewController: MKMapViewDelegate {
    
    private enum SpotErrors: Error {
        case noRouteFound
    }
    
    func showRouteOnMap(startCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) async throws {
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: startCoordinate, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .walking
        
        let directions = MKDirections(request: request)
        
        guard let route = try await directions.calculate().routes.first else { throw SpotErrors.noRouteFound }
        self.mapView.addOverlay(route.polyline)
        self.mapView.setVisibleMapRect(
            route.polyline.boundingMapRect,
            edgePadding: UIEdgeInsets.init(top: 80.0, left: 20.0, bottom: 100.0, right: 20.0),
            animated: true
        )
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: any MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 1.0
        renderer.lineDashPattern = [3, 5]
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? StopLocation else { return nil }
        let identifier = StopLocation.reuseIdentifier
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? CustomAnnotationView
        annotationView?.annotation = annotation
        return annotationView
    }
}
