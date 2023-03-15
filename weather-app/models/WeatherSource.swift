//
//  WeatherSource.swift
//  weather-app
//
//  Created by Landon Rohatensky on 2023-03-15.
//

import Foundation

struct WeatherSource: Codable {
    let title, slug: String
    let url: String
    let crawlRate: Int

    enum CodingKeys: String, CodingKey {
        case title, slug, url
        case crawlRate = "crawl_rate"
    }
}
