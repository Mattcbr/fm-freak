//
//  AlbumDetailView.swift
//  fm freak
//
//  Created by Matheus Queiroz on 6/30/21.
//

import Foundation

protocol AlbumDetailView: BaseView {
    func showAlbumDetail(forAlbum album:AlbumDetailedInfo)
    func showAddToFavoriteCompleteDialog(wasSuccessful: Bool)
    func showRemoveFromFavoriteCompleteDialog(wasSuccessful: Bool)
}
