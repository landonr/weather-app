//
//  ImageService.swift
//  weather-app
//
//  Created by Landon Rohatensky on 2023-03-15.
//

import RxSwift
import UIKit
import SDWebImage

protocol IImageService {
    func getImage(_ name: String) -> Single<UIImage>
}

class LocalImageService: IImageService {
    func getImage(_ name: String) -> Single<UIImage> {
        if let image = UIImage(named: name) {
            return .just(image)
        }
        return .error(RxError.noElements)
    }
}

class HTTPImageService: IImageService {
    private let imageURL = "https://cdn.faire.com/static/mobile-take-home/icons/%@.png"

    func getImage(_ name: String) -> Single<UIImage> {
        guard let requestURL = URL(string: String(format: imageURL, name)) else {
            return .error(RxError.noElements)
        }
        return Single.create { singleObserver in
            SDWebImageManager.shared.loadImage(with: requestURL, progress: nil) { image, _, error, cacheType, _, _ in
                if let error = error {
                    print(error)
                    singleObserver(.failure(error))
                } else if let image = image {
                    print("loaded \(name) image from \(cacheType.localized)")
                    singleObserver(.success(image))
                } else {
                    singleObserver(.failure(RxError.unknown))
                }
            }
            return Disposables.create()
        }
    }
}

extension SDImageCacheType {
    var localized: String {
        switch self {
        case .all:
            return "all"
        case .none:
            return "none"
        case .disk:
            return "disk"
        case .memory:
            return "memory"
        default:
            return "not found"
        }
    }
}
