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

        // Creating the presenter
        if presenter == nil {
            presenter = AlbumDetailPresenter(networkManager: NetworkManager.sharedInstance,
                                             databaseManager: DatabaseManager.sharedInstance)
            presenter?.attachView(self)
        }
        
        albumCoverImageView.image = albumCover
        loadingIndicator.hidesWhenStopped = true
        requestAlbumDetail()
        checkAndShowLoadingIndicator()
    }
    
    /**
     This asks the presenter to request the album details
     */
    private func requestAlbumDetail() {
        if let albumNameUnwrapped = albumName, let artistNameUnwrapped = artistName, let presenterUnwrapped = presenter {
            presenterUnwrapped.requestDetails(forAlbum: albumNameUnwrapped, artistName: artistNameUnwrapped)
        }
    }
    
    /**
     This checks if the loading indicator should be shown and shows it if is supposed to
     */
    private func checkAndShowLoadingIndicator() {
        if !isFavorite {
            loadingIndicator.startAnimating()
            view.bringSubviewToFront(loadingIndicator)
        }
    }
    
    // MARK: UI Setup
    
    /**
     This shows the album information according to the parameters received
     
     - Parameter album: The album that should be shown in the view
     */
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
    
    /**
     This sets the favorites button text according to the database status of the album
     */
    func setupFavoritesButton() {
        if let presenterUnwrapped = presenter, let albumNameUnwrapped = albumName {
            isFavorite = presenterUnwrapped.isAlbumFavorite(albumName: albumNameUnwrapped)
        }
        let buttonText = isFavorite ? "Remove from favorites" : "Add to favorites"
        
        favoritesButton.titleLabel?.textAlignment = .center
        favoritesButton.setTitle(buttonText, for: .normal)
    }
    
    func showError(_ error: Error?) {
        let alert = UIAlertController (title: "Error",
                                       message: "There was an error requesting details for the selected album",
                                       preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Favorites
    
    @IBAction func didSelectFavoritesButton(_ sender: Any) {
        if !isFavorite {
            presenter?.didSelectFavoritesButton(withImage: albumCover)
        } else {
            showDeleteConfirmationDialog()
        }
    }
    
    /**
     This shows a confirmation dialog before removing an album from the favorites database
     */
    private func showDeleteConfirmationDialog() {
        let alert = UIAlertController(title: "Are you sure?",
                                      message: "Do you really want to remove this album from your favorites?",
                                      preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Remove", style: .destructive) {[weak self] (action) in
            self?.presenter?.didSelectFavoritesButton(withImage: self?.albumCover)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    /**
     This shows a dialog to confirm that the album was added to the database
     
     - Parameter wasSuccessful: Confirms if the addition was successful or not
     */
    func showAddToFavoriteCompleteDialog(wasSuccessful: Bool) {
        let title = wasSuccessful ? "Album saved" : "Error saving"
        let message = wasSuccessful ? "This album was added to your favorites" : "We're sorry, but there was an error when trying to add this album to your favorites"
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true) {[weak self] in
            self?.setupFavoritesButton()
        }
    }
    
    /**
     This shows a dialog to confirm that the album was removed from the database
     
     - Parameter wasSuccessful: Confirms if the addition was successful or not
     */
    func showRemoveFromFavoriteCompleteDialog(wasSuccessful: Bool) {
        let title = wasSuccessful ? "Album removed" : "Error removing"
        let message = wasSuccessful ? "This album was removed from your favorites" : "We're sorry, but there was an error when trying to remove this album from your favorites"
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true) {[weak self] in
            self?.setupFavoritesButton()
        }
    }
}
