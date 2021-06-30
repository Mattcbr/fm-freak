//
//  AlbumsRequestInfo.swift
//  fm freak
//
//  Created by Matheus Queiroz on 6/29/21.
//

import Foundation

class AlbumsRequestInfo: Codable {
    let albums: AlbumsArray?
    
    init(albums: AlbumsArray) {
        self.albums = albums
    }
}
