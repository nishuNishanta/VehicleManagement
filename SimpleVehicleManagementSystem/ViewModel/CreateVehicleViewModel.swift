//
//  CreateVehicleViewModel.swift
//  SimpleVehicleManagementSystem
//
//  Created by Nishu Nishanta on 25/01/25.
//

import SwiftUI
import Foundation

class CreateVehicleViewModel: ObservableObject {
    // MARK: - Published: Data Arrays
    @Published private(set) var allBrands: [Brand] = []       // Holds all brands from the JSON
    @Published var filteredBrands: [Brand] = []               // The currently displayed / filtered brand list
    
    // MARK: - Published: User Selection
    @Published var selectedBrand: Brand? = nil
    @Published var selectedSeries: Series? = nil
    @Published var selectedYear: Int? = nil
    @Published var fuelType: FuelType = .gasoline
    
    // MARK: - Published: Search
    @Published var searchQuery: String = "" {
        didSet {
            updateFilteredBrands()
        }
    }
    @Published var selectedCars: [Vehicle] = [] {
        didSet {
            saveToUserDefaults()
        }
    }
    
    
    // MARK: - Initializer
       init(allBrands: [Brand] = VehicleDataService.shared.loadBrands()) {
           self.allBrands = allBrands
           self.filteredBrands = allBrands
           loadFromUserDefaults()
       }

    
    // MARK: - Public Methods
    
    /// Creates a new `Vehicle` instance from user selections, or returns `nil` if incomplete.
    func createVehicle() -> Vehicle? {
        guard
            let brand = selectedBrand,
            let series = selectedSeries,
            let year = selectedYear
        else {
            return nil
        }
        
        return Vehicle(
            brandName: brand.brandName,
            seriesName: series.name,
            year: year,
            fuelType: fuelType
        )
    }
    
    /// Resets all user selections and search
    func resetSelections() {
        selectedBrand = nil
        selectedSeries = nil
        selectedYear = nil
        fuelType = .gasoline
        searchQuery = ""
    }
   
    /// Returns the series filtered by the current search term, if applicable.
    var filteredSeries: [Series] {
        guard let brand = selectedBrand else { return [] } // Ensure a brand is selected
        
        if searchQuery.isEmpty {
            return brand.seriesList // Return the full list if no search query
        } else {
            return brand.seriesList.filter {
                $0.name.localizedCaseInsensitiveContains(searchQuery) // Filter by series name
            }
        }
    }
    var filteredYears: [Int] {
        guard let series = selectedSeries else { return [] } // Ensure a series is selected
        
        // Get available years for the series
        let years = Array(series.minYear...series.maxYear)
        
        // Filter years based on the search query
        if searchQuery.isEmpty {
            return years // Return all years if no search query
        } else {
            return years.filter {
                "\($0)".localizedCaseInsensitiveContains(searchQuery) // Match year as a string
            }
        }
    }
    
    
    /// Returns the range of valid years for the selected series, or an empty array if none is selected.
    var availableYears: [Int] {
        guard let series = selectedSeries else { return [] }
        return Array(series.minYear...series.maxYear)
    }
    
    
    var currentSelectionLabel: String {
        var parts: [String] = []
        if let b = selectedBrand?.brandName { parts.append(b) }
        if let s = selectedSeries?.name { parts.append(s) }
        if let y = selectedYear { parts.append("\(y)") }
       
        return parts.joined(separator: ", ")
    }
    
    
    // MARK: - Private: Loading & Filtering
    
    private func loadData() {
        // Load all brand data from your data service
        allBrands = VehicleDataService.shared.loadBrands()
        
        // Initially, show all of them in the filtered list
        filteredBrands = allBrands
    }
    // MARK: - Add a New Car
    func addCar(_ car: Vehicle) {
        selectedCars.append(car)
    }
    // MARK: - Remove a Car
    func removeCar(at index: Int) {
        selectedCars.remove(at: index)
    }
    // MARK: - Persistence (UserDefaults)
    private func saveToUserDefaults() {
        if let data = try? JSONEncoder().encode(selectedCars) {
            UserDefaults.standard.set(data, forKey: "SelectedCars")
        }
    }
    private func loadFromUserDefaults() {
        if let data = UserDefaults.standard.data(forKey: "SelectedCars"),
           let cars = try? JSONDecoder().decode([Vehicle].self, from: data) {
            self.selectedCars = cars
        }
    }
    
    /// Updates `filteredBrands` based on `searchQuery`.
    private func updateFilteredBrands() {
        if searchQuery.isEmpty {
            filteredBrands = allBrands
        } else {
            filteredBrands = allBrands.filter { brand in
                brand.brandName.localizedCaseInsensitiveContains(searchQuery)
            }
        }
    }
    
}

#if DEBUG
extension CreateVehicleViewModel {
    func testLoadFromUserDefaults() {
        loadFromUserDefaults()
    }
}
#endif
