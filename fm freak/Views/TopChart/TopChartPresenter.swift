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
    
    func requestAlbuns() {
        networkManager.makeHipHopRequest { [weak self] result in
            switch result {
            case .success(let albunsArray):
                if let albumsOnly = albunsArray.albums?.album {
                    self?.baseView?.addNewAlbunsToArray(newAlbuns: albumsOnly)
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
            }
        }
    }
    
    private func requestImages(forAlbum album: Album, completion: @escaping (_ imagesDictionary: (String, UIImage)) -> Void) {
        self.networkManager.requestImage(forAlbum: album) { albumCoverDictionary in
            completion(albumCoverDictionary)
        }
    }
    
}
