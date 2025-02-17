//
//  SelectFuelTypeView.swift
//  SimpleVehicleManagementSystem
//
//  Created by Nishu Nishanta on 26/01/25.
//

import SwiftUI

struct SelectFuelTypeView: View {
    @ObservedObject var createVM: CreateVehicleViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    // Local state to control navigation
    @State private var navigateToCarDashboard = false
    @State private var createdVehicle: Vehicle? = nil
    
    var body: some View {
        ZStack {
            Color(.darkGray).ignoresSafeArea()
            
            VStack {
                // 1) The hidden NavigationLink
                NavigationLink(
                    destination: CarDashboardView(
                        vehicle: createdVehicle ?? Vehicle(brandName: "Placeholder", seriesName: "", year: 0, fuelType: .other),
                        createVM: createVM
                    ),
                    isActive: $navigateToCarDashboard
                ) {
                    EmptyView()
                }
                .hidden()
                
                // 2) The list of possible fuel types
                List {
                    Section(header: Text(createVM.currentSelectionLabel)
                        .foregroundColor(.yellow)
                        .font(.headline)
                    ) {
                        ForEach(FuelType.allCases) { fuel in
                            Button {
                                createVM.fuelType = fuel
                                finalizeVehicle()
                            } label: {
                                HStack {
                                    Text(fuel.rawValue)
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                            }
                            .listRowBackground(Color.clear)
                        }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
            }
        }
        // Custom nav bar
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    // Reset selection if user goes back
                    createVM.selectedYear = nil
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                }
            }
            ToolbarItem(placement: .principal) {
                Text("Car selection")
                    .foregroundColor(.white)
                    .font(.headline)
            }
        }
    }
    
    // MARK: - Finalize Vehicle and Navigate
    private func finalizeVehicle() {
        if let newVehicle = createVM.createVehicle() {
            // Store the real vehicle
            createVM.addCar(newVehicle) 
            self.createdVehicle = newVehicle
            // Trigger the hidden NavigationLink
            self.navigateToCarDashboard = true
        } else {
            // handle error if incomplete
            print("Error: Incomplete selection")
        }
    }
}
