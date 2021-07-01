//
//  AlbumDetailPresenter.swift
//  fm freak
//
//  Created by Matheus Queiroz on 6/30/21.
//

import UIKit

class AlbumDetailPresenter<T: AlbumDetailView>: BasePresenter<T> {
    
    let networkManager: NetworkManager
    let databaseManager: DatabaseManager
    var selectedAlbum: AlbumDetailedInfo?
    
    init(networkManager: NetworkManager, databaseManager: DatabaseManager) {
        self.networkManager = networkManager
        self.databaseManager = databaseManager
    }
    
    // MARK: Requests
    
    /**
     This checks and directs the requests to the network or the database
     
     - Parameter albumName: The name of the album that should be requested
     - Parameter artistName: The artist related to the album that should be requested
     */
    func requestDetails(forAlbum albumName: String, artistName: String) {
        if isAlbumFavorite(albumName: albumName) {
            getAlbumFromDatabase(albumName: albumName)
        } else {
            getAlbumFromNetwork(albumName: albumName, artistName: artistName)
        }
    }
    
    // MARK: Network Management
    
    /**
     This requests the album information to the network
     
     - Parameter albumName: The name of the album that should be requested
     - Parameter artistName: The artist related to the album that should be requested
     */
    func getAlbumFromNetwork(albumName: String, artistName: String) {
        let sanitizedAlbumName = sanitizeStringBeforeRequest(stringToSanitize: albumName)
        let sanitizedArtistName = sanitizeStringBeforeRequest(stringToSanitize: artistName)
        networkManager.makeDetailedAlbumRequest(forAlbum: sanitizedAlbumName, artistName: sanitizedArtistName) { [weak self] result in
            switch result {
            case .success(let albumDetail):
                if let detailedInfo = albumDetail.album {
                    self?.selectedAlbum = detailedInfo
                    self?.baseView?.showAlbumDetail(forAlbum: detailedInfo)
                }
            case .failure(let error):
                self?.baseView?.showError(error)
            }
        }
    }
    
    /**
     This sanitizes a string before making a request to the network
     
     - Parameter stringToSanitize: The string that should be sanitized
     - Returns: The input string sanitized
     */
    func sanitizeStringBeforeRequest(stringToSanitize: String) -> String {
        let sanitizedString = stringToSanitize.replacingOccurrences(of: " ", with: "%20")
        return sanitizedString
    }
    
    // MARK: Database Management
    
    /**
     This requests the album information to the database
     
     - Parameter albumName: The name of the album that should be requested
     - Parameter artistName: The artist related to the album that should be requested
     */
    func getAlbumFromDatabase(albumName: String) {
        let allFavorites = databaseManager.getAllFavorites()
        let albumFromDatabase = allFavorites.first(where: {$0.name?.lowercased() == albumName.lowercased()})
        if let albumFromDatabaseUnwrapped = albumFromDatabase {
            self.baseView?.showAlbumDetail(forAlbum: albumFromDatabaseUnwrapped)
            selectedAlbum = albumFromDatabaseUnwrapped
        } else {
            self.baseView?.showError(nil)
        }
    }
    
    /**
     This verifies if the album is saved on the database
     
     - Parameter albumName: The name of the album that should be verified
     - Returns: A Boolean indicating if the album is saved or not in the database
     */
    func isAlbumFavorite(albumName: String) -> Bool {
        let favoritesArray = databaseManager.getAllFavorites()
        return favoritesArray.contains(where: {$0.name?.lowercased() == albumName.lowercased()})
    }
    
    /**
     This checks if the selected album should be saved or removed from the database
     
     - Parameter image: The album image
     */
    func didSelectFavoritesButton(withImage image: UIImage?) {
        if let selectedAlbumUnwrapped = selectedAlbum {
            if isAlbumFavorite(albumName: selectedAlbum?.name ?? "") {
                removeAlbumFromFavorites(albumToRemove: selectedAlbumUnwrapped)
            } else {
                addAlbumToFavorites(albumToAdd: selectedAlbumUnwrapped, albumImage: image ?? UIImage())
            }
        }
    }
    
    /**
     This adds an album to the database
     
     - Parameter albumToAdd: The album that should be added to the database
     - Parameter albumImage: The image of the album that should be added to the database
     */
    private func addAlbumToFavorites(albumToAdd: AlbumDetailedInfo, albumImage: UIImage) {
        databaseManager.addToFavorites(album: albumToAdd, image: albumImage) { [weak self] result in
            switch result {
            case .success:
                self?.baseView?.showAddToFavoriteCompleteDialog(wasSuccessful: true)
            case .failure(let error):
                self?.baseView?.showAddToFavoriteCompleteDialog(wasSuccessful: false)
                print(error.localizedDescription)
            }
        }
    }
    
    /**
     This removes an album from the database
     
     - Parameter albumToRemove: The album that should be removed from the database
     */
    private func removeAlbumFromFavorites(albumToRemove: AlbumDetailedInfo) {
        databaseManager.removeFromFavorites(album: albumToRemove) { [weak self] result in
            switch result {
            case .success:
                self?.baseView?.showRemoveFromFavoriteCompleteDialog(wasSuccessful: true)
            case .failure(let error):
                self?.baseView?.showRemoveFromFavoriteCompleteDialog(wasSuccessful: false)
                print(error.localizedDescription)
            }
        }
    }
    
    
}
