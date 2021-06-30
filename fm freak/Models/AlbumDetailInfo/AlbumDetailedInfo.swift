//
//  AlbumDetailedInfo.swift
//  fm freak
//
//  Created by Matheus Queiroz on 6/30/21.
//

import Foundation

class AlbumDetailedInfo: Codable {
    let name: String?
    let artist: String?
    let listeners: String?
    let tracks: TracksArray?
    let wiki: Wiki?
    
    init(name: String, artist: String, listeners: String, tracks: TracksArray, wiki: Wiki) {
        self.name = name
        self.artist = artist
        self.listeners = listeners
        self.tracks = tracks
        self.wiki = wiki
    }
}
