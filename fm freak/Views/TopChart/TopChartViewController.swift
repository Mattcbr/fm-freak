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
    
    private var selectedAlbum: Album?
    private var isFavoritesTab = false
    
    // MARK: LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if presenter == nil {
            if let tabBarIndex = tabBarController?.selectedIndex {
                isFavoritesTab = tabBarIndex == 0
            }
            presenter = TopChartPresenter(networkManager: NetworkManager.sharedInstance,
                                          databaseManager: DatabaseManager.sharedInstance,
                                          isFavoritesScreen: isFavoritesTab)
            presenter?.attachView(self)
        }
        
        presenter?.getAlbums()
        
        let albumCell = UINib.init(nibName: "TopChartCollectionViewCell", bundle: nil)
        self.collectionView.register(albumCell, forCellWithReuseIdentifier:reuseIdentifier)
        
        if presenter?.shouldShowAppReview() == true {
            if let foregroundScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                SKStoreReviewController.requestReview(in: foregroundScene)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isFavoritesTab {
            presenter?.getAlbums()
        }
    }
    
    // MARK: TopChartView Protocol Functions
    func addNewAlbunsToArray(newAlbuns: [Album]) {
        if isFavoritesTab {
            albunsArray = newAlbuns
        } else {
            albunsArray.append(contentsOf: newAlbuns)
        }
        collectionView.reloadData()
    }
    
    func addNewImagesToDictionary(newImages: [String : UIImage]) {
        newImages.forEach({ (key, value) in
            imagesDictionary[key] = value
        })
        collectionView.reloadData()
    }
    
    func showError(_ error: Error?) {
        let alert = UIAlertController (title: "Error",
                                       message: "There was an error requesting more albums",
                                       preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)

        self.present(alert, animated: true, completion: nil)
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
        selectedAlbum = albunsArray[indexPath.row]
        performSegue(withIdentifier: Utils().detailsSegueKey, sender: self)
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
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Utils().detailsSegueKey {
            guard let destinationVCAsDetail = segue.destination as? AlbumDetailViewController else {return}
            destinationVCAsDetail.albumName = selectedAlbum?.name
            destinationVCAsDetail.artistName = selectedAlbum?.artist?.name
            if let albumName = selectedAlbum?.name, let albumCover = imagesDictionary[albumName] {
                destinationVCAsDetail.albumCover = albumCover
            }
        }
    }
    
}
