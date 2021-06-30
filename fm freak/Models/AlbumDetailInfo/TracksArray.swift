//
//  TracksArray.swift
//  fm freak
//
//  Created by Matheus Queiroz on 6/30/21.
//

import Foundation

class TracksArray: Codable {
    let track: [Track]?
    
    init(track:[Track]) {
        self.track = track
    }
}
