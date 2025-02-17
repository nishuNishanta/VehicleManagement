import SwiftUI

struct YourCarsView: View {
    @ObservedObject var createVM: CreateVehicleViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedCar: Vehicle? // Track the selected car
    @State private var navigateToSelectBrand = false // Navigation state
    
    var body: some View {
        ZStack {
            Color.lighBg.ignoresSafeArea() // Background for the entire view
            
            VStack(spacing: 0) {
                if createVM.selectedCars.isEmpty {
                    // Empty State Message
                    Text("No cars selected. Add a new car!")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                } else {
                    ScrollView { // Replace List with ScrollView for full control
                        VStack(spacing: 10) {
                            ForEach(createVM.selectedCars, id: \.id) { car in
                                CarRowView(
                                    car: car,
                                    isSelected: car == selectedCar, // Check if the car is selected
                                    onDelete: {
                                        if let index = createVM.selectedCars.firstIndex(where: { $0.id == car.id }) {
                                            createVM.removeCar(at: index)
                                            // If the selected car is deleted, clear selection
                                            if selectedCar == car {
                                                selectedCar = nil
                                            }
                                        }
                                    }
                                )
                                .onTapGesture {
                                    selectedCar = car // Set selected car on tap
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                Spacer()
                
                // Add New Car Button
                Button(action: {
                    navigateToSelectBrand = true // Trigger navigation
                }) {
                    Text("Add new car")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.buttonPrim)
                        .foregroundColor(.white)
                        .cornerRadius(50)
                        .padding(.horizontal)
                }
                
                // NavigationLink for SelectBrandView
                NavigationLink(
                    destination: SelectBrandView(createVM: createVM),
                    isActive: $navigateToSelectBrand
                ) {
                    EmptyView() // Hidden NavigationLink
                }
            }
        }
        .onAppear {
            // Automatically select the last car if not already selected
            selectedCar = createVM.selectedCars.last
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                }
            }
            ToolbarItem(placement: .principal) {
                Text("Your Cars")
                    .foregroundColor(.white)
                    .font(.headline)
            }
        }
    }
}
