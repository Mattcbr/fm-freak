//
//  Artist.swift
//  fm freak
//
//  Created by Matheus Queiroz on 6/29/21.
//

import Foundation

class Artist: Codable {
    let name: String?
    
    init(name: String) {
        self.name = name
    }
}
