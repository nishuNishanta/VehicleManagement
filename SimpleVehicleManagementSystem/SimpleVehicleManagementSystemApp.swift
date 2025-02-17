//
//  SimpleVehicleManagementSystemApp.swift
//  SimpleVehicleManagementSystem
//
//  Created by Nishu Nishanta on 25/01/25.
//

import SwiftUI

@main
struct SimpleVehicleManagementSystemApp: App {
    var body: some Scene {
        WindowGroup {
            DashboardView(createVM: CreateVehicleViewModel())
        }
    }
}
