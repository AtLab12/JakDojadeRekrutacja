//
//  ViewController.swift
//  JakDojadeRek
//
//  Created by Mikolaj Zawada on 09/05/2024.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var stations: [Station] = []
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SpotCell.nib(), forCellReuseIdentifier: SpotCell.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(named: "BackgroundColor")
        fetchStationInfo()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    private func showFetchErrorAlert() {
        let alert = UIAlertController(title: "Error", message: "Failed to load stations", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in
            self.fetchStationInfo()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    private func fetchStationInfo() {
        activityIndicator.startAnimating()
        Task {
            do {
                stations = try await ApiClient().fetchStationsInfo()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                }
            } catch {
                DispatchQueue.main.async {
                    self.showFetchErrorAlert()
                }
            }
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "spotDetails") as? SpotDetailsViewController
        if let vc {
            vc.station = stations[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        stations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SpotCell.identifier, for: indexPath) as! SpotCell
        cell.spotNameLabel.text = stations[indexPath.row].name
        cell.addressLabel.text = stations[indexPath.row].address
        
        let availableVehicles = stations[indexPath.row].availableVehicles
        cell.bikesAvailableLabel.text = String(availableVehicles)
        
        if availableVehicles > 0 {
            cell.bikesAvailableLabel.textColor = UIColor(named: "BikeGreen")
        } else {
            cell.bikesAvailableLabel.textColor = .red
        }
        
        cell.placesAvailableLabel.text = String(stations[indexPath.row].availablePlaces)
        cell.distanceLabel.text = stations[indexPath.row].distanceInMeters
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
}
