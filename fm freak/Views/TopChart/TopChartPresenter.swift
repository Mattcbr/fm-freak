//
//  TopChartPresenter.swift
//  fm freak
//
//  Created by Matheus Queiroz on 6/29/21.
//

import Foundation
import UIKit

class TopChartPresenter<T: TopChartView>: BasePresenter<T> {
    
    private let networkManager = NetworkManager.sharedInstance
    private var lastRequestedPage = 1
    private var isLoadingData = false
    
    func requestAlbuns() {
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
                            self?.requestImages(forAlbum: album) { imageTuple in
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
    
    private func requestImages(forAlbum album: Album, completion: @escaping (_ imagesDictionary: (String, UIImage)) -> Void) {
        self.networkManager.requestImage(forAlbum: album) { albumCoverDictionary in
            completion(albumCoverDictionary)
        }
    }
    
    func requestMoreAlbums() {
        lastRequestedPage += isLoadingData ? 0 : 1
        if lastRequestedPage <= 20 {
            requestAlbuns()
        }
    }
    
    // MARK: App Review
    
    func shouldShowAppReview() -> Bool {
        let appClosingCounter = UserDefaults.standard.integer(forKey: Utils().appClosingKey)
        return appClosingCounter >= 9
    }
}
