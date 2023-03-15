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

protocol IViewModel {
    func getImageForState(state: String) -> Single<UIImage>
    var manager: IWeatherManager { get }
    var weatherData: Observable<[ConsolidatedWeather]> { get }
    var title: Observable<String> { get }
}

class ViewModel: IViewModel {
    private static let maxItems = 1
    private let disposeBag = DisposeBag()
    private let woeid = 4418
    let manager: IWeatherManager
    private let weatherDataSubject = BehaviorSubject<WeatherData?>(value: nil)
    var weatherData: Observable<[ConsolidatedWeather]> {
        weatherDataSubject.filterNil().map { data in
            if ViewModel.maxItems > 0 {
                return Array(data.consolidatedWeather.prefix(ViewModel.maxItems))
            }
            return data.consolidatedWeather
        }
    }
    var title: Observable<String> {
        weatherDataSubject.map {
            $0?.title ?? NSLocalizedString("loading", comment: "Loading")
        }
    }
    
    init(manager: IWeatherManager) {
        self.manager = manager
        sharedInit()
    }
 
    init() {
        manager = WeatherManager(service: HTTPWeatherService())
        sharedInit()
    }
    
    private func sharedInit() {
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
