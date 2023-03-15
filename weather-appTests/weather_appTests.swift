//
//  weather_appTests.swift
//  weather-appTests
//
//  Created by Landon Rohatensky on 2023-03-15.
//

import RxBlocking
import XCTest

@testable import weather_app

final class weather_appTests: XCTestCase {
    let woeid: Int = 4418
    let manager = WeatherManager(service: FileWeatherService())
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testLoadsData() {
        // test that weather returns

        do {
            let viewModel: IViewModel = ViewModel(manager: manager)
            let result = try viewModel.weatherData.toBlocking().first()
            XCTAssert(result?.count ?? 0 > 0)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testConsolidatedWeatherExists() {
        // tests that the weather matches what we know

        do {
            let viewModel: IViewModel = ViewModel(manager: manager)
            let result = try viewModel.weatherData.toBlocking().first()
            XCTAssert(result?.first?.id == 4805883302248448)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testTitleData() {
        // tests that a tile returns

        do {
            let viewModel: IViewModel = ViewModel(manager: manager)
            let result = try viewModel.title.toBlocking().first()
            XCTAssertNotEqual(result, "")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testImageData() {
        // tests all images load

        do {
            let viewModel: IViewModel = ViewModel(manager: manager)
            let results = try viewModel.weatherData.toBlocking().first()
            for result in results ?? [] {
                let image = try viewModel.getImageForState(state: result.weatherStateAbbr).toBlocking().first()
                XCTAssertNotNil(image)
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
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
