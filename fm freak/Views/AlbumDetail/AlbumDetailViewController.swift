//
//  AlbumDetailViewController.swift
//  fm freak
//
//  Created by Matheus Queiroz on 6/30/21.
//

import UIKit

class AlbumDetailViewController: UIViewController, AlbumDetailView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var tracksCountLabel: UILabel!
    @IBOutlet weak var listenersLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var albumCoverImageView: UIImageView!
    @IBOutlet weak var favoritesButton: UIButton!
    
    private var presenter: AlbumDetailPresenter<AlbumDetailViewController>?
    private var isFavorite = false
    
    var albumName: String?
    var artistName: String?
    var albumCover = UIImage(named: "AppDefault")
    
    // MARK: Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if presenter == nil {
            presenter = AlbumDetailPresenter(networkManager: NetworkManager.sharedInstance,
                                             databaseManager: DatabaseManager.sharedInstance)
            presenter?.attachView(self)
        }
        
        if let albumNameUnwrapped = albumName, let artistNameUnwrapped = artistName, let presenterUnwrapped = presenter {
            let sanitizedAlbumName = presenterUnwrapped.sanitizeStringBeforeRequest(stringToSanitize: albumNameUnwrapped)
            let sanitizedArtistName = presenterUnwrapped.sanitizeStringBeforeRequest(stringToSanitize: artistNameUnwrapped)
            presenterUnwrapped.requestDetails(forAlbum: sanitizedAlbumName, artistName: sanitizedArtistName)
        }
        
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.startAnimating()
        view.bringSubviewToFront(loadingIndicator)
        
        albumCoverImageView.image = albumCover
    }
    
    // MARK: UI Setup
    
    func showAlbumDetail(forAlbum album: AlbumDetailedInfo) {
        titleLabel.text = album.name
        artistLabel.text = album.artist
        if let tracksNumber = album.tracks?.track?.count {
            tracksCountLabel.text = "# of tracks: \(tracksNumber)"
        } else {
            tracksCountLabel.text = "# of tracks unavailable"
        }
        
        if let listenersNumber = album.listeners {
            listenersLabel.text = "# of listeners: \(listenersNumber)"
        } else {
            listenersLabel.text = "# of listeners unavailable"
        }
        
        if let releaseDate = album.wiki?.published {
            releaseDateLabel.text = "Release date: \(releaseDate)"
        } else {
            releaseDateLabel.text = "Release date unavailable"
        }
        
        if let content = album.wiki?.content {
            contentLabel.text = content
        } else {
            contentLabel.text = "Details unavailable"
        }
        setupFavoritesButton()
        loadingIndicator.stopAnimating()
        albumCoverImageView.image = albumCover
    }
    
    func setupFavoritesButton() {
        let isFavorite = presenter!.isAlbumFavorite()
        let buttonText = isFavorite ? "Remove from favorites" : "Add to favorites"
        
        favoritesButton.titleLabel?.textAlignment = .center
        favoritesButton.setTitle(buttonText, for: .normal)
    }
    
    func showError(_ error: Error) {
        //TODO: Implement this
    }
    
    // MARK: Favorites
    
    @IBAction func didSelectFavoritesButton(_ sender: Any) {
        if !isFavorite {
            presenter?.didSelectFavoritesButton()
        } else {
            showDeleteConfirmationDialog()
        }
    }
    
    private func showDeleteConfirmationDialog() {
        let alert = UIAlertController(title: "Are you sure?",
                                      message: "Do you really want to remove this album from your favorites?",
                                      preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Remove", style: .destructive) {[weak self] (action) in
            self?.presenter?.didSelectFavoritesButton()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}
