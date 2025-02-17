//
//  Brand.swift
//  SimpleVehicleManagementSystem
//
//  Created by Nishu Nishanta on 25/01/25.
//

import Foundation
import Foundation

struct Brand: Identifiable, Codable {
    let id = UUID()
    let brandName: String
    let supportedFeatures: [String]
    let seriesList: [Series]

    enum CodingKeys: String, CodingKey {
        case brandName = "Brand Name"
        case supportedFeatures = "Supported Features"
        case seriesName = "Series Name"
    }
    //  **Manual Initializer for Testing**
      init(brandName: String, supportedFeatures: [String], seriesList: [Series]) {
          self.brandName = brandName
          self.supportedFeatures = supportedFeatures
          self.seriesList = seriesList
      }


    // MARK: - Custom Decoder (Handles Nested JSON)
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        brandName = try container.decode(String.self, forKey: .brandName)

        // Decode features (split by newlines)
        let rawFeatures = try container.decode(String.self, forKey: .supportedFeatures)
        supportedFeatures = rawFeatures
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        // Decode "Series Name" (Complex JSON)
        let rawSeries = try container.decode([[String: [String: String]]].self, forKey: .seriesName)
        
        seriesList = rawSeries.compactMap { seriesDict in
            guard let seriesName = seriesDict.keys.first,
                  let yearsDict = seriesDict[seriesName],
                  let minYear = yearsDict["Minimum Supported Year"],
                  let maxYear = yearsDict["Maximum Supported Year"],
                  let minYearInt = Int(minYear),
                  let maxYearInt = Int(maxYear) else {
                return nil
            }
            return Series(name: seriesName, minYear: minYearInt, maxYear: maxYearInt)
        }
    }

    // MARK: - Custom Encoder (Ensures Encoding Works)
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(brandName, forKey: .brandName)
        
        // Convert feature list back to newline-separated string
        let featuresString = supportedFeatures.joined(separator: "\n")
        try container.encode(featuresString, forKey: .supportedFeatures)
        
        // Convert seriesList back to JSON format
        let seriesData = seriesList.map { series in
            [series.name: [
                "Minimum Supported Year": "\(series.minYear)",
                "Maximum Supported Year": "\(series.maxYear)"
            ]]
        }
        
        try container.encode(seriesData, forKey: .seriesName)
    }
}
