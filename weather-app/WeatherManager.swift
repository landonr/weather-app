//
//  WeatherManager.swift
//  weather-app
//
//  Created by Landon Rohatensky on 2023-03-15.
//

import RxSwift
import UIKit

protocol IWeatherService {
    func getWeatherData(woeid: Int) -> Single<WeatherData>
    func getWeatherStateImage(stateAbbr: String) -> UIImage
}

class FileWeatherService: IWeatherService {
    private let decoder = JSONDecoder()

    func getWeatherData(woeid: Int) -> Single<WeatherData> {
        return Single.create { [weak decoder] singleObserver in
            if let path = Bundle.main.url(forResource: "\(woeid)", withExtension: "json"),
            let decoder = decoder {
                do {
                    let data = try Data(contentsOf: path, options: .mappedIfSafe)
                    let weatherData = try decoder.decode(WeatherData.self, from: data)
                    singleObserver(.success(weatherData))
                    return Disposables.create()
                } catch {
                    print("error: \(error)")
                    singleObserver(.failure(error))
                    return Disposables.create()
                }
            }
            singleObserver(.failure(RxError.noElements))
            return Disposables.create()
        }
    }
    
    func getWeatherStateImage(stateAbbr: String) -> UIImage {
        return UIImage()
    }
}

protocol IWeatherManager {
    var service: IWeatherService { get }
    func getWeatherData(woeid: Int) -> Single<WeatherData>
    func getWeatherStateImage(stateAbbr: String) -> UIImage
}

class WeatherManager: IWeatherManager {
    var service: IWeatherService = FileWeatherService()
    
    func getWeatherData(woeid: Int) -> Single<WeatherData> {
        return service.getWeatherData(woeid: woeid)
    }
    
    func getWeatherStateImage(stateAbbr: String) -> UIImage {
        return service.getWeatherStateImage(stateAbbr: stateAbbr)
    }
    
    
}
