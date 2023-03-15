//
//  ViewModel.swift
//  weather-app
//
//  Created by Landon Rohatensky on 2023-03-15.
//

import Foundation
import RxSwift
import RxOptional
import UIKit

class ViewModel {
    private let disposeBag = DisposeBag()
    private let woeid = 4418
    private let manager = WeatherManager()
    private let weatherDataSubject = BehaviorSubject<WeatherData?>(value: nil)
    var weatherData: Observable<[ConsolidatedWeather]> {
        weatherDataSubject.filterNil().map { data in
            return data.consolidatedWeather.first != nil ? [data.consolidatedWeather.first!] : []
        }
    }
    var title: Observable<String> {
        weatherDataSubject.map {
            $0?.title ?? NSLocalizedString("loading", comment: "Loading")
        }
    }
    
    init() {
        manager.getWeatherData(woeid: woeid)
            .subscribe { [weak weatherDataSubject] event in
            switch event {
            case .success(let data):
                weatherDataSubject?.onNext(data)
            case .failure(let error):
                print(error)
            }
        }.disposed(by: disposeBag)
    }
    
    func getImageForState(state: String) -> Single<UIImage> {
        return manager.getWeatherStateImage(stateAbbr: state)
    }
}
