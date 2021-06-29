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
    private var imagesDictionary = [String: UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if presenter == nil {
            presenter = TopChartPresenter()
            presenter?.attachView(self)
        }
        
        presenter?.requestAlbuns()
        
        let albumCell = UINib.init(nibName: "TopChartCollectionViewCell", bundle: nil)
        self.collectionView.register(albumCell, forCellWithReuseIdentifier:reuseIdentifier)
    }
    
    // MARK: TopChartView Protocol Functions
    func addNewAlbunsToArray(newAlbuns: [Album]) {
        albunsArray.append(contentsOf: newAlbuns)
        collectionView.reloadData()
    }
    
    func addNewImagesToDictionary(newImages: [String : UIImage]) {
        newImages.forEach({ (key, value) in
            imagesDictionary[key] = value
        })
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? TopChartCollectionViewCell else {
            fatalError("Not a Top Chart cell")
        }
        if albunsArray.count > indexPath.row {
            let albumToSetup = albunsArray[indexPath.row]
            cell.setupCell(forAlbum: albumToSetup)
            
            if let albumName = albumToSetup.name, let imageForAlbum = imagesDictionary[albumName] {
                cell.setupCover(image: imageForAlbum)
            }
        }
        return cell
    }
    
}
