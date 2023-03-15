//
//  WeatherCountry.swift
//  weather-app
//
//  Created by Landon Rohatensky on 2023-03-15.
//

import Foundation

struct WeatherCountry: Codable {
    let title, locationType: String
    let woeid: Int
    let lattLong: String

    enum CodingKeys: String, CodingKey {
        case title
        case locationType = "location_type"
        case woeid
        case lattLong = "latt_long"
    }
}
