//
//  CarRowView.swift
//  SimpleVehicleManagementSystem
//
//  Created by Nishu Nishanta on 26/01/25.
//
import SwiftUI

struct CarRowView: View {
    let car: Vehicle
    let isSelected: Bool // Pass whether this car is selected
    let onDelete: () -> Void // Callback for delete action

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(car.brandName) - \(car.seriesName)")
                    .foregroundColor(Color.fontDark)
                    .font(.headline)

                Text("\(Utility.formatYear(car.year)) - \(car.fuelType.rawValue)")
                    .foregroundColor(Color.fontLight)
                    .font(.subheadline)
            }

            Spacer()

            // Show delete button only if the car is not selected
            if !isSelected {
                Button(action: onDelete) {
                    Image("Deleteimage")
                       // .foregroundColor(.white)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(isSelected ? Color.darkBg : Color.darkBg) // Dark gray for selected, light gray for unselected
        )
        .overlay(
            // Add a yellow border if the car is selected
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? Color.buttonPrim : Color.clear, lineWidth: 2)
        )
    }
}
