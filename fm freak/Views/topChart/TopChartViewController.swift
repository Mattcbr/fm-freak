//
//  TopChartViewController.swift
//  fm freak
//
//  Created by Matheus Queiroz on 6/29/21.
//

import UIKit

class TopChartViewController: UICollectionViewController, TopChartView {
    
    private var lastRequestedPage = 1
    private let reuseIdentifier = "albumCell"
    
    private var presenter: TopChartPresenter<TopChartViewController>?
    
    private var albunsArray = [Album]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if presenter == nil {
            presenter = TopChartPresenter()
            presenter?.attachView(self)
        }
        
        presenter?.requestAlbuns()
    }
    
    // MARK: TopChartView Protocol Functions
    func addNewAlbunsToArray(newAlbuns: [Album]) {
        albunsArray.append(contentsOf: newAlbuns)
        collectionView.reloadData()
    }
    
    func showError(_ error: Error) {
        //TODO: Implement This
    }
    
    // MARK: Collection view
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albunsArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? UICollectionViewCell else {
            fatalError("Not a details cell")
        }
        cell.backgroundColor = .red
        return cell
    }
    
}
