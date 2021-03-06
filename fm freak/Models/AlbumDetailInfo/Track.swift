//
//  Track.swift
//  fm freak
//
//  Created by Matheus Queiroz on 6/30/21.
//

import Foundation

class Track: Codable {
    let name: String?
    let duration: Int?
    
    init(name: String?, duration: Int?) {
        self.name = name
        self.duration = duration
    }
}
