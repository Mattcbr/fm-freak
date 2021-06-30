//
//  AlbumDetailPresenter.swift
//  fm freak
//
//  Created by Matheus Queiroz on 6/30/21.
//

import Foundation

class AlbumDetailPresenter<T: AlbumDetailView>: BasePresenter<T> {
    
    var networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func requestDetails(forAlbum albumName: String, artistName: String) {
        networkManager.makeDetailedAlbumRequest(forAlbum: albumName, artistName: artistName) { [weak self] result in
            switch result {
            case .success(let albumDetail):
                if let detailedInfo = albumDetail.album {
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
    
}
