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
     
     private func createBasicListLayout() -> UICollectionViewLayout {
         let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(1))
         let item = NSCollectionLayoutItem(layoutSize: itemSize)
         let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(1))
         let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                          subitems: [item])
         let section = NSCollectionLayoutSection(group: group)
          section.interGroupSpacing = 16
         let layout = UICollectionViewCompositionalLayout(section: section)
         return layout
     }
     
     private func bindCellImage(_ cell: WeatherDataCollectionViewCell, weatherState: String) {
          viewModel.getImageForState(state: weatherState).subscribe({ event in
               switch event {
               case .failure:
                    break
               case .success(let image):
                    cell.setImage(image)
               }
          }).disposed(by: cell.disposeBag)
     }
     
     private func bindToCollectionView() {
          viewModel.weatherData
               .bind(to: collectionView.rx.items(cellIdentifier: "weatherData")) { [weak self] index, model, cell in
                    guard let cell = cell as? WeatherDataCollectionViewCell else {
                         return
                    }
                    cell.configure(model)
                    self?.bindCellImage(cell, weatherState: model.weatherStateAbbr)
               }.disposed(by: disposeBag)
     }
     
     override func viewDidLoad() {
          super.viewDidLoad()
          navigationController?.navigationBar.prefersLargeTitles = true
          collectionView.collectionViewLayout = createBasicListLayout()
          
          bindToCollectionView()
          viewModel.title
               .bind(to: navigationItem.rx.title).disposed(by: disposeBag)
          // Do any additional setup after loading the view.
     }
}
