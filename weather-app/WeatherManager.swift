//
//  WeatherManager.swift
//  weather-app
//
//  Created by Landon Rohatensky on 2023-03-15.
//

import RxSwift
import UIKit

protocol IWeatherManager {
    func getWeatherData(woeid: Int) -> Single<WeatherData>
    func getWeatherStateImage(stateAbbr: String) -> Single<UIImage>
}

class WeatherManager: IWeatherManager {
    var service: IWeatherService = HTTPWeatherService()
    
    func getWeatherData(woeid: Int) -> Single<WeatherData> {
        return service.getWeatherData(woeid: woeid)
    }
    
    func getWeatherStateImage(stateAbbr: String) -> Single<UIImage> {
        return service.getWeatherStateImage(stateAbbr: stateAbbr)
    }
}
