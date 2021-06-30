//
//  Album.swift
//  fm freak
//
//  Created by Matheus Queiroz on 6/29/21.
//

import UIKit
import Foundation

class Album: Codable {
    let name: String?
    let artist: Artist?
    let image: [AlbumImage]?
    
    init(name: String, artist: Artist, image: [AlbumImage]) {
        self.name = name
        self.artist = artist
        self.image = image
    }
}
