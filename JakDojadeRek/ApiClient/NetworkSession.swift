//
//  NetworkSession.swift
//  JakDojadeRek
//
//  Created by Mikolaj Zawada on 11/05/2024.
//

import Foundation

class NetworkSession: NetworkService {
    
    private enum Errors: Error {
        case invalidURL
    }
    
    public init() {}
    
    func fetchData<T>(from url: String) async throws -> T where T : Decodable {
        guard let url = URL(string: url) else { throw Errors.invalidURL }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
}
