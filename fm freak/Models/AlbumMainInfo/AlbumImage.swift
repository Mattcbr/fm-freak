//
//  AlbumImage.swift
//  fm freak
//
//  Created by Matheus Queiroz on 6/29/21.
//

import Foundation

class AlbumImage: Codable {
    let text: String?
    let size: String?
    
    enum CodingKeys: String, CodingKey {
        case text = "#text"
        case size = "size"
    }
    
    init(text: String, size: String) {
        self.text = text
        self.size = size
    }
}
