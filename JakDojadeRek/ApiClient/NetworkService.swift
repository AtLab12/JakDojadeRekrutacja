//
//  NetworkService.swift
//  JakDojadeRek
//
//  Created by Mikolaj Zawada on 11/05/2024.
//

import Foundation

protocol NetworkService {
    func fetchData<T: Decodable>(from url: String) async throws -> T
}
