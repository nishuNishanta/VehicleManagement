//
//  VehicleDataServiceTests.swift
//  SimpleVehicleManagementSystemTests
//
//  Created by Nishu Nishanta on 29/01/25.
//

import XCTest
@testable import SimpleVehicleManagementSystem

final class VehicleDataServiceTests: XCTestCase {

    // MARK: -Test Valid JSON Parsing
    func testParseBrands_validJSON() {
        // Arrange
        let json = """
        [
            {
                "Brand Name": "Toyota",
                "Supported Features": "Feature1\\nFeature2",
                "Series Name": [
                    {
                        "Corolla": {
                            "Minimum Supported Year": "2000",
                            "Maximum Supported Year": "2020"
                        }
                    }
                ]
            }
        ]
        """
        let mockData = Data(json.utf8)

        // Act
        let service = VehicleDataService.shared
        let brands = service.testableParseBrands(from: mockData)

        // Assert
        XCTAssertEqual(brands.count, 1, "There should be exactly 1 brand parsed.")
        XCTAssertEqual(brands[0].brandName, "Toyota", "Brand name should match.")
        XCTAssertEqual(brands[0].supportedFeatures, ["Feature1", "Feature2"], "Supported features should be split correctly.")
        XCTAssertEqual(brands[0].seriesList.count, 1, "There should be 1 series parsed.")
        XCTAssertEqual(brands[0].seriesList[0].name, "Corolla", "Series name should match.")
        XCTAssertEqual(brands[0].seriesList[0].minYear, 2000, "Min year should be parsed correctly.")
        XCTAssertEqual(brands[0].seriesList[0].maxYear, 2020, "Max year should be parsed correctly.")
    }

    // MARK: - Test Invalid JSON (Malformed Structure)
    func testParseBrands_invalidJSON() {
        // Arrange
        let json = """
        {
            "Invalid Key": "Invalid Value"
        }
        """
        let mockData = Data(json.utf8)

        // Act
        let service = VehicleDataService.shared
        let brands = service.testableParseBrands(from: mockData)

        // Assert
        XCTAssertEqual(brands.count, 0, "There should be no brands parsed due to invalid JSON structure.")
    }

    // MARK: - Test Missing Fields (Edge Case)
    func testParseBrands_missingFields() {
        // Arrange
        let json = """
        [
            {
                "Brand Name": "Honda"
            }
        ]
        """
        let mockData = Data(json.utf8)

        // Act
        let service = VehicleDataService.shared
        let brands = service.testableParseBrands(from: mockData)

        // Assert
        XCTAssertEqual(brands.count, 0, "Parsing should fail if required fields are missing.")
    }

    // MARK: -  Test Corrupted Data
    func testParseBrands_corruptedData() {
        // Arrange
        let corruptedData = Data([0x00, 0x01, 0x02]) // Random bytes

        // Act
        let service = VehicleDataService.shared
        let brands = service.testableParseBrands(from: corruptedData)

        // Assert
        XCTAssertEqual(brands.count, 0, "Parsing should fail gracefully if the data is corrupted.")
    }
}

