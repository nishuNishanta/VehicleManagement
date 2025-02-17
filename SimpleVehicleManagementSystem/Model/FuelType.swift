//
//  FuelType.swift
//  SimpleVehicleManagementSystem
//
//  Created by Nishu Nishanta on 25/01/25.
//

import Foundation

enum FuelType: String, CaseIterable, Codable, Identifiable {
    case diesel = "Diesel"
    case gasoline = "Gasoline"
    case hybrid = "Hybrid"
    case electric = "Electric"
    case other = "Other"
    
    var id: String { self.rawValue }
}

