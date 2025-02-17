//
//  CreateVehicleViewModelTests.swift
//  SimpleVehicleManagementSystemTests
//
//  Created by Nishu Nishanta on 29/01/25.
//

import Foundation
import XCTest
@testable import SimpleVehicleManagementSystem

final class CreateVehicleViewModelTests: XCTestCase {
    var viewModel: CreateVehicleViewModel!

    override func setUp() {
        super.setUp()
        viewModel = CreateVehicleViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    // MARK: - Test Cases
    func testCreateVehicle_success() {
        // Arrange
        let seriesList = [
            Series(name: "Corolla", minYear: 2000, maxYear: 2020)
        ]
        
        let brand = Brand(
            brandName: "Toyota",
            supportedFeatures: ["Diagnostics", "Battery Check"],
            seriesList: seriesList
        )
        
        let series = brand.seriesList.first!
        let year = 2020
        viewModel.selectedBrand = brand
        viewModel.selectedSeries = series
        viewModel.selectedYear = year
        viewModel.fuelType = .gasoline

        // Act
        let vehicle = viewModel.createVehicle()

        // Assert
        XCTAssertNotNil(vehicle, "Vehicle should be created successfully.")
        XCTAssertEqual(vehicle?.brandName, "Toyota")
        XCTAssertEqual(vehicle?.seriesName, "Corolla")
        XCTAssertEqual(vehicle?.year, 2020)
        XCTAssertEqual(vehicle?.fuelType, .gasoline)
    }


    func testCreateVehicle_incompleteSelection() {
        // Arrange
        viewModel.selectedBrand = nil // Missing brand
        viewModel.selectedSeries = nil
        viewModel.selectedYear = nil

        // Act
        let vehicle = viewModel.createVehicle()

        // Assert
        XCTAssertNil(vehicle, "Vehicle should not be created if selections are incomplete.")
    }

    func testResetSelections() {
        // Arrange
        viewModel.selectedBrand = Brand(brandName: "Toyota", supportedFeatures: [], seriesList: [])
        viewModel.selectedSeries = Series(name: "Corolla", minYear: 2000, maxYear: 2020)
        viewModel.selectedYear = 2020
        viewModel.fuelType = .diesel
        viewModel.searchQuery = "Search Query"

        // Act
        viewModel.resetSelections()

        // Assert
        XCTAssertNil(viewModel.selectedBrand)
        XCTAssertNil(viewModel.selectedSeries)
        XCTAssertNil(viewModel.selectedYear)
        XCTAssertEqual(viewModel.fuelType, .gasoline)
        XCTAssertEqual(viewModel.searchQuery, "")
    }

    func testFilteredBrands() {
        // Arrange
        let brand1 = Brand(brandName: "Toyota", supportedFeatures: [], seriesList: [])
        let brand2 = Brand(brandName: "Ford", supportedFeatures: [], seriesList: [])
        viewModel = CreateVehicleViewModel(allBrands: [brand1, brand2]) // Inject mock data

        // Act
        viewModel.searchQuery = "Toyota"

        // Assert
        XCTAssertEqual(viewModel.filteredBrands.count, 1, "Filtered brands should contain only the matching brand.")
        XCTAssertEqual(viewModel.filteredBrands.first?.brandName, "Toyota")
    }


    func testFilteredSeries() {
        // Arrange
        let series1 = Series(name: "Corolla", minYear: 2000, maxYear: 2020)
        let series2 = Series(name: "Camry", minYear: 2005, maxYear: 2023)
        let brand = Brand(brandName: "Toyota", supportedFeatures: [], seriesList: [series1, series2])
        viewModel.selectedBrand = brand

        // Act
        viewModel.searchQuery = "Corolla"

        // Assert
        XCTAssertEqual(viewModel.filteredSeries.count, 1, "Filtered series should contain only the matching series.")
        XCTAssertEqual(viewModel.filteredSeries.first?.name, "Corolla")
    }

    func testFilteredYears() {
        // Arrange
        let series = Series(name: "Corolla", minYear: 2000, maxYear: 2020)
        viewModel.selectedSeries = series

        // Act
        viewModel.searchQuery = "2005"

        // Assert
        XCTAssertEqual(viewModel.filteredYears.count, 1, "Filtered years should contain only the matching year.")
        XCTAssertEqual(viewModel.filteredYears.first, 2005)
    }

    func testLoadFromUserDefaults() {
        // Arrange
        let vehicle = Vehicle(brandName: "Toyota", seriesName: "Corolla", year: 2020, fuelType: .gasoline)
        let data = try! JSONEncoder().encode([vehicle])
        UserDefaults.standard.set(data, forKey: "SelectedCars")

        // Act
        viewModel.testLoadFromUserDefaults()

        // Assert
        XCTAssertEqual(viewModel.selectedCars.count, 1, "The selected cars should be loaded from UserDefaults.")
        XCTAssertEqual(viewModel.selectedCars.first?.brandName, "Toyota", "The car's brand name should match.")
    }


    func testCurrentSelectionLabel() {
        // Arrange
        let brand = Brand(brandName: "Toyota", supportedFeatures: [], seriesList: [])
        let series = Series(name: "Corolla", minYear: 2000, maxYear: 2020)
        let year = 2020
        viewModel.selectedBrand = brand
        viewModel.selectedSeries = series
        viewModel.selectedYear = year

        // Act
        let label = viewModel.currentSelectionLabel

        // Assert
        XCTAssertEqual(label, "Toyota, Corolla, 2020", "The label should correctly reflect the current selection.")
    }
}
