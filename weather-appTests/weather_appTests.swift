//
//  weather_appTests.swift
//  weather-appTests
//
//  Created by Landon Rohatensky on 2023-03-15.
//

import XCTest
@testable import weather_app

final class weather_appTests: XCTestCase {
    let woeid: Int = 4418
    let manager = WeatherManager()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testLoadsData() {
        let data = manager.getWeatherData(woeid: woeid)
        XCTAssertNotNil(data)
    }
    
    func testConsolidatedWeatherExists() {
        let data = manager.getWeatherData(woeid: woeid)
        XCTAssert(data?.consolidatedWeather.first?.id == 4805883302248448)
    }
    
    func testWoeIDMatches() {
        let data = manager.getWeatherData(woeid: woeid)
        XCTAssert(data?.woeid == woeid)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        let data = manager.getWeatherData(woeid: woeid)
        self.measure {
            // Put the code you want to measure the time of here.
            let data = manager.getWeatherData(woeid: woeid)
        }
    }

}
