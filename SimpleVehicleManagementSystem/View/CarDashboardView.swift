import SwiftUI

struct CarDashboardView: View {
    let vehicle: Vehicle
    @ObservedObject var createVM: CreateVehicleViewModel
    @State private var showYourCars = false // State to control navigation
   
    // Dynamically fetch brand details (e.g., features) using brandName
    private var brand: Brand? {
        VehicleDataService.shared.loadBrands()
            .first(where: { $0.brandName == vehicle.brandName })
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            
            // Background Image (fill the screen)
            GeometryReader { geo in
                Image("bgImage")    // Replace with your actual background asset
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
                  
                
            }
            
            // Foreground Layout
            VStack(spacing: 0) {
                
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80)
                    .padding(.top, 20)
                
                // Vehicle Info Row
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        
                        Text("\(vehicle.brandName) - \(vehicle.seriesName)")
                            .foregroundColor(.white)
                            .font(.title.bold())
                            .accessibilityIdentifier("CarTitle")
                        
                        
                        Text("\(Utility.formatYear(vehicle.year)) - \(vehicle.fuelType.rawValue)")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                            .accessibilityIdentifier("CarSubtitle")
                    }
                    
                    Spacer()
                    
                    // Menu button to navigate to YourCarsView
                    Button(action: {
                        showYourCars = true
                    }) {
                        Image("menuImage")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .padding(8)
                            .tint(Color.white)
                        //.background(Color.white.opacity(0.2))
                            .clipShape(Circle())
                    }
                    .accessibilityIdentifier("MenuButton")
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                // Hidden NavigationLink for YourCarsView
                NavigationLink(
                    destination: YourCarsView(createVM: createVM),
                    isActive: $showYourCars
                ) {
                    EmptyView()
                }
                .hidden()
                
                // Car image
                Image("carImage")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 240)
                    .padding(.vertical, 16)
                
                // Section Title
                Text("Discover your car")
                    .foregroundColor(Color.fontLight)
                    .font(.title3.weight(.medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 8)
                
                // Feature List
                if let features = brand?.supportedFeatures {
                    VStack(spacing: 2) {
                        ForEach(features, id: \.self) { feature in
                            NavigationLink(destination: Text("\(feature) Screen")) {
                                menuRow(title: feature)
                            }
                            .accessibilityIdentifier(feature)
                        }
                    }
                    
                    .padding(.horizontal, 20)
                } else {
                    // Fallback if brand is not found
                    Text("No features found for \(vehicle.brandName).")
                        .foregroundColor(.white)
                        .accessibilityIdentifier("NoFeaturesMessage")
                }
                
                Spacer()
            }
            .navigationBarHidden(true)
        } .background(Color.darkBg)
    }
    
    // MARK: - Menu Row Helper
    @ViewBuilder
    private func menuRow(title: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.white)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.white)
            
        }
        .padding()
        .background(Color.lighBg)
        .cornerRadius(3)
    }
}
#if DEBUG
extension CarDashboardView {
    // Testing-only accessor for `brand`
    func getTestBrand() -> Brand? {
        return self.brand
    }

    // Testing-only accessor and setter for `showYourCars`
    func getTestShowYourCars() -> Bool {
        return self.showYourCars
    }

    mutating func setTestShowYourCars(_ value: Bool) {
        self.showYourCars = value
    }
}
#endif
