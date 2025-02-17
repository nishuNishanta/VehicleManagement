//
//  VehicleDataService.swift
//  SimpleVehicleManagementSystem
//
//  Created by Nishu Nishanta on 25/01/25.
//

import Foundation

class VehicleDataService {
    static let shared = VehicleDataService()
    
    private init() {}
    
    func loadBrands() -> [Brand] {
       
        guard let url = Bundle.main.url(forResource: "Brand", withExtension: "json") else {
            print("JSON file not found.")
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            return try parseBrands(from: data)
        } catch {
            print("Error loading JSON while parsing: \(error)")
            return []
        }
    }
    

    // MARK: - Parse JSON Using Codable
       fileprivate func parseBrands(from data: Data) throws -> [Brand] {
           let decodedBrands = try JSONDecoder().decode([Brand].self, from: data)
           return decodedBrands
       }
}
// MARK: - Extension for Testing Only
#if DEBUG
extension VehicleDataService {
    func testableParseBrands(from data: Data) -> [Brand] {
        if let brands = try? parseBrands(from: data) {
            return brands
        } else {
            print("Test Parsing Error: Failed to decode JSON")
            return []
        }
    }
}
#endif
