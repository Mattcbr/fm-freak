//
//  TopChartPresenter.swift
//  fm freak
//
//  Created by Matheus Queiroz on 6/29/21.
//

import Foundation
import UIKit

class TopChartPresenter<T: TopChartView>: BasePresenter<T> {
    
    let networkManager: NetworkManager
    let databaseManager: DatabaseManager
    
    private var lastRequestedPage = 1
    private var isLoadingData = false
    private var isFavoritesScreen: Bool
    
    init(networkManager: NetworkManager, databaseManager: DatabaseManager, isFavoritesScreen: Bool) {
        self.networkManager = networkManager
        self.databaseManager = databaseManager
        self.isFavoritesScreen = isFavoritesScreen
    }
    
    func getAlbums() {
        if isFavoritesScreen {
            requestAlbumsFromDatabase()
        } else {
            requestAlbunsFromNetwork()
        }
    }
    
    private func requestAlbunsFromNetwork() {
        if !isLoadingData {
            isLoadingData = true
            networkManager.makeHipHopRequest(forPage: lastRequestedPage) { [weak self] result in
                switch result {
                case .success(let albunsArray):
                    if let albumsOnly = albunsArray.albums?.album {
                        self?.baseView?.addNewAlbunsToArray(newAlbuns: albumsOnly)
                        self?.isLoadingData = false
                        var imagesDictionary = [String: UIImage]()
                        for (index, album) in albumsOnly.enumerated() {
                            self?.requestImagesFromNetwork(forAlbum: album) { imageTuple in
                                imagesDictionary[imageTuple.0] = imageTuple.1
                                
                                if index == albumsOnly.count - 1 {
                                    self?.baseView?.addNewImagesToDictionary(newImages: imagesDictionary)
                                }
                            }
                        }
                    }
                case .failure(let error):
                    self?.baseView?.showError(error)
                    self?.isLoadingData = false
                }
            }
        }
    }
    
    private func requestAlbumsFromDatabase() {
        let detailedAlbumsArray = databaseManager.getAllFavorites()
        var albumsArray = [Album]()
        
        detailedAlbumsArray.forEach { detailedAlbum in
            let albumArtist = Artist(name: detailedAlbum.artist)
            let convertedAlbum = Album(name: detailedAlbum.name, artist: albumArtist, image: [])
            albumsArray.append(convertedAlbum)
        }
        
        self.baseView?.addNewAlbunsToArray(newAlbuns: albumsArray)
        self.requestImagesFromDatabase(forAlbums: albumsArray)
    }
    
    private func requestImagesFromNetwork(forAlbum album: Album, completion: @escaping (_ imagesDictionary: (String, UIImage)) -> Void) {
        self.networkManager.requestImage(forAlbum: album) { albumCoverDictionary in
            completion(albumCoverDictionary)
        }
    }
    
    private func requestImagesFromDatabase(forAlbums albums: [Album]) {
        let albumsNameArray = albums.map({$0.name})
        self.databaseManager.getSavedImage(forAlbums: albumsNameArray) { [weak self] albumImagesDict in
            self?.baseView?.addNewImagesToDictionary(newImages: albumImagesDict)
        }
    }
    
    func requestMoreAlbums() {
        lastRequestedPage += isLoadingData ? 0 : 1
        if lastRequestedPage <= 20 && !isFavoritesScreen {
            requestAlbunsFromNetwork()
        }
    }
    
    // MARK: App Review
    
    func shouldShowAppReview() -> Bool {
        let appClosingCounter = UserDefaults.standard.integer(forKey: Utils().appClosingKey)
        return appClosingCounter >= 9
    }
}
