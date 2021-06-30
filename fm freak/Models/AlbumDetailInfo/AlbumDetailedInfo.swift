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
}
