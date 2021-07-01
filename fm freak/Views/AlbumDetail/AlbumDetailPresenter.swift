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
    
    func requestDetails(forAlbum albumName: String, artistName: String) {
        if isAlbumFavorite(albumName: albumName) {
            getAlbumFromDatabase(albumName: albumName)
        } else {
            getAlbumFromNetwork(albumName: albumName, artistName: artistName)
        }
    }
    
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
    
    func getAlbumFromDatabase(albumName: String) {
        let allFavorites = databaseManager.getAllFavorites()
        let selectedAlbum = allFavorites.first(where: {$0.name == albumName})
        if let selectedAlbumUnwrapped = selectedAlbum {
            self.baseView?.showAlbumDetail(forAlbum: selectedAlbumUnwrapped)
        } else {
//            self.baseView?.showError()
        }
    }
    
    func sanitizeStringBeforeRequest(stringToSanitize: String) -> String {
        let sanitizedString = stringToSanitize.replacingOccurrences(of: " ", with: "%20")
        return sanitizedString
    }
    
    // MARK: Database Management
    
    func isAlbumFavorite(albumName: String) -> Bool {
        let favoritesArray = databaseManager.getAllFavorites()
        return favoritesArray.contains(where: {$0.name == albumName})
    }
    
    func didSelectFavoritesButton(withImage image: UIImage?) {
        if let selectedAlbumUnwrapped = selectedAlbum {
            if isAlbumFavorite(albumName: selectedAlbum?.name ?? "") {
                removeAlbumFromFavorites(albumToRemove: selectedAlbumUnwrapped)
            } else {
                addAlbumToFavorites(albumToAdd: selectedAlbumUnwrapped, albumImage: image ?? UIImage())
            }
        }
    }
    
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
