//
//  AlbumDetailPresenter.swift
//  fm freak
//
//  Created by Matheus Queiroz on 6/30/21.
//

import Foundation

class AlbumDetailPresenter<T: AlbumDetailView>: BasePresenter<T> {
    
    let networkManager: NetworkManager
    let databaseManager: DatabaseManager
    var selectedAlbum: AlbumDetailedInfo?
    
    init(networkManager: NetworkManager, databaseManager: DatabaseManager) {
        self.networkManager = networkManager
        self.databaseManager = databaseManager
    }
    
    func requestDetails(forAlbum albumName: String, artistName: String) {
        networkManager.makeDetailedAlbumRequest(forAlbum: albumName, artistName: artistName) { [weak self] result in
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
    
    func sanitizeStringBeforeRequest(stringToSanitize: String) -> String {
        let sanitizedString = stringToSanitize.replacingOccurrences(of: " ", with: "%20")
        return sanitizedString
    }
    
    // MARK: Database Management
    
    func isAlbumFavorite() -> Bool {
        let favoritesArray = databaseManager.getAllFavorites()
        return favoritesArray.contains(where: {$0.name == selectedAlbum?.name})
    }
    
    func didSelectFavoritesButton() {
        if let selectedAlbumUnwrapped = selectedAlbum {
            if isAlbumFavorite() {
                removeAlbumFromFavorites(albumToRemove: selectedAlbumUnwrapped)
            } else {
                addAlbumToFavorites(albumToAdd: selectedAlbumUnwrapped)
            }
        }
    }
    
    private func addAlbumToFavorites(albumToAdd: AlbumDetailedInfo) {
        databaseManager.addToFavorites(album: albumToAdd)
    }
    
    private func removeAlbumFromFavorites(albumToRemove: AlbumDetailedInfo) {
        databaseManager.removeFromFavorites(album: albumToRemove)
    }
    
    
}
