//
//  TopChartViewController.swift
//  fm freak
//
//  Created by Matheus Queiroz on 6/29/21.
//

import UIKit
import StoreKit

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
        
        if presenter?.shouldShowAppReview() == true {
            if let foregroundScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                SKStoreReviewController.requestReview(in: foregroundScene)
            }
        }
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detailViewSegue", sender: self)
    }
    
    // MARK: Infinite Scroll
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewHeight = scrollView.frame.size.height
        let scrollContentSizeHeight = scrollView.contentSize.height
        let scrollOffset = scrollView.contentOffset.y
        
        let diff = scrollContentSizeHeight - scrollOffset - scrollViewHeight    //This detects if the scroll is near the botom of the scroll view
        
        if (diff<30) {    //If the scroll is near the bottom make a new request.
            presenter?.requestMoreAlbums()
        }
    }
    
}
