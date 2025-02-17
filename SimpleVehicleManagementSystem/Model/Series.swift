//
//  Series.swift
//  SimpleVehicleManagementSystem
//
//  Created by Nishu Nishanta on 25/01/25.
//

import Foundation

struct Series: Identifiable, Codable {
    let id = UUID()   // For SwiftUI lists
    let name: String
    let minYear: Int
    let maxYear: Int
    
}

