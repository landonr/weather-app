//
//  WeatherService.swift
//  weather-app
//
//  Created by Landon Rohatensky on 2023-03-15.
//

import Foundation
import RxSwift
import UIKit
import Alamofire

protocol IWeatherService {
    func getWeatherData(woeid: Int) -> Single<WeatherData>
    func getWeatherStateImage(stateAbbr: String) -> Single<UIImage>
}

class HTTPWeatherService: IWeatherService {
    private let dataURL = "https://cdn.faire.com/static/mobile-take-home/%d.json"
    private let imageService: IImageService = HTTPImageService()
    
    func getWeatherData(woeid: Int) -> Single<WeatherData> {
        guard let requestURL = URL(string: String(format: dataURL, woeid)) else {
            return .error(RxError.unknown)
        }
        return Single.create { singleObserver in
            AF.request(requestURL, method: .get).responseDecodable(of: WeatherData.self) { response in
                switch response.result {
                case .success(let data):
                    singleObserver(.success(data))
                case .failure(let error):
                    singleObserver(.failure(error))
                }
            }
            return Disposables.create()
        }
    }

    func getWeatherStateImage(stateAbbr: String) -> Single<UIImage> {
        return imageService.getImage(stateAbbr)
    }
}

class FileWeatherService: IWeatherService {
    private let decoder = JSONDecoder()
    private let imageService: IImageService = LocalImageService()
    
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
    
    func getWeatherStateImage(stateAbbr: String) -> Single<UIImage> {
        if let image = UIImage(named: stateAbbr) {
            return .just(image)
        }
        return .error(RxError.noElements)
    }
}
