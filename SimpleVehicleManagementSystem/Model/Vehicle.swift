//
//  Vehicle.swift
//  SimpleVehicleManagementSystem
//
//  Created by Nishu Nishanta on 25/01/25.
//

import Foundation

struct Vehicle: Identifiable, Codable,Equatable {
    let id: UUID
    let brandName: String
    let seriesName: String
    let year: Int
    let fuelType: FuelType
    
    // Basic initializer
    init(brandName: String, seriesName: String, year: Int, fuelType: FuelType) {
        self.id = UUID()
        self.brandName = brandName
        self.seriesName = seriesName
        self.year = year
        self.fuelType = fuelType
    }
}

