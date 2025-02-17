//
//  DashboardView.swift
//  VehicleManagementSystem
//
//  Created by Nishu Nishanta on 25/01/25.
//

import SwiftUI

struct DashboardView: View {
    @ObservedObject var createVM: CreateVehicleViewModel
    @State private var navigateToCreateVehicle = false
    @State private var navigateToCarDashboard = false
    @State private var selectedVehicle: Vehicle? // Store the last selected vehicle
    
    var body: some View {
        NavigationView {
            ZStack {
                // MARK: - Background Image using GeometryReader
                GeometryReader { geo in
                    Image("bgImage")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.height)
                        .clipped()
                        .ignoresSafeArea()
                   
                }
                
                // MARK: - Foreground Content
                VStack {
                    // Logo at the top, centered
                    Image("logo")
                        .resizable()
                        .frame(width: 100, height: 80) // Adjust to match the design
                        .padding(.top, 20)
                    
                    Spacer()
                    
                    // NavigationLink to CarDashboardView (if cars exist)
                    if let vehicle = selectedVehicle {
                        NavigationLink(
                            destination: CarDashboardView(vehicle: vehicle, createVM: createVM),
                            isActive: $navigateToCarDashboard
                        ) {
                            EmptyView()
                        }
                        .hidden()
                    }
                    
                    // Add Car Button
                    NavigationLink(
                        destination: SelectBrandView(createVM: createVM),
                        isActive: $navigateToCreateVehicle
                    ) {
                        Image("AddButton")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .background(
                                Circle()
                                    .fill(Color.black.opacity(0.5))
                            )
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                }
            }
            .background(Color.darkBg)
            .navigationBarHidden(true) // Hide the default navigation bar
            .onAppear {
                // Trigger navigation to CarDashboardView only if cars exist
                handleOnAppear()
            }
        }
    }
    
    /// Handles the logic for navigating to CarDashboardView on appearance
    private func handleOnAppear() {
        guard !createVM.selectedCars.isEmpty else { return } // If no cars exist, do nothing
        if let lastCar = createVM.selectedCars.last {
            selectedVehicle = lastCar // Set the last selected vehicle
            if !navigateToCreateVehicle { // Avoid overriding existing navigation
                navigateToCarDashboard = true
            }
        }
    }
}

//// MARK: - SwiftUI Preview
//#Preview {
//    DashboardView(createVM: CreateVehicleViewModel())
//}
