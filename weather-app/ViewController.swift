//
//  ViewController.swift
//  weather-app
//
//  Created by Landon Rohatensky on 2023-03-15.
//

import UIKit
import RxSwift
import RxDataSources

class ViewController: UIViewController {
     private let disposeBag = DisposeBag()
     private let viewModel = ViewModel()
     @IBOutlet weak var collectionView: UICollectionView!
     
     fileprivate func bindToCollectionView() {
          viewModel.weatherData
               .bind(to: collectionView.rx.items(cellIdentifier: "weatherData")) { index, model, cell in
                    guard let cell = cell as? WeatherDataCollectionViewCell else {
                         return
                    }
                    cell.configure(model)
               }.disposed(by: disposeBag)
     }
     
     override func viewDidLoad() {
          super.viewDidLoad()
          collectionView.collectionViewLayout = createRowLayout()
          
          bindToCollectionView()
          viewModel.title
               .bind(to: navigationItem.rx.title).disposed(by: disposeBag)
          // Do any additional setup after loading the view.
     }
     
     func createRowLayout() -> UICollectionViewLayout {
          let itemSize = NSCollectionLayoutSize(
               widthDimension: .fractionalWidth(1.0),
               heightDimension: .fractionalHeight(1.0)
          )
          let item = NSCollectionLayoutItem(layoutSize: itemSize)
          
          //3
          let groupSize = NSCollectionLayoutSize(
               widthDimension: .fractionalWidth(1.0),
               heightDimension: .fractionalWidth(0.33)
          )
          let group = NSCollectionLayoutGroup.horizontal(
               layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(0.2)
               ), subitems: [item])
          
          //4
          let section = NSCollectionLayoutSection(group: group)
          section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
          
          //5
          let spacing = CGFloat(10)
          group.interItemSpacing = .fixed(spacing)
          section.interGroupSpacing = spacing
          
          //6
          let layout = UICollectionViewCompositionalLayout(section: section)
          return layout
     }
}

class WeatherDataCollectionViewCell: UICollectionViewCell {
     @IBOutlet weak var imageView: UIImageView?
     @IBOutlet weak var temperatureLabel: UILabel?
     @IBOutlet weak var lowTemperatureLabel: UILabel?
     @IBOutlet weak var highTemperatureLabel: UILabel?
     @IBOutlet weak var weatherStateLabel: UILabel?
     
     func configure(_ data: ConsolidatedWeather) {
          temperatureLabel?.text = "\(data.theTemp)"
          lowTemperatureLabel?.text = "\(data.minTemp)"
          highTemperatureLabel?.text = "\(data.maxTemp)"
          weatherStateLabel?.text = "\(data.weatherStateName)"
     }
}
