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
                                               heightDimension: .fractionalHeight(0.2))
         let item = NSCollectionLayoutItem(layoutSize: itemSize)
         let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .fractionalHeight(1.0))
         let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                          subitems: [item])
         let section = NSCollectionLayoutSection(group: group)

         let layout = UICollectionViewCompositionalLayout(section: section)
         return layout
     }
     
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
          collectionView.collectionViewLayout = createBasicListLayout()
          
          bindToCollectionView()
          viewModel.title
               .bind(to: navigationItem.rx.title).disposed(by: disposeBag)
          // Do any additional setup after loading the view.
     }
}
