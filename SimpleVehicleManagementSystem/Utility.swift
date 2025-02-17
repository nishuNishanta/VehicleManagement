//
//  Utility.swift
//  SimpleVehicleManagementSystem
//
//  Created by Nishu Nishanta on 27/01/25.
//

import Foundation
class Utility {
    static func formatYear(_ year: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none // Ensure no formatting like commas
        return formatter.string(from: NSNumber(value: year)) ?? "\(year)"
    }
}
