//
//  Wiki.swift
//  fm freak
//
//  Created by Matheus Queiroz on 6/30/21.
//

import Foundation

class Wiki: Codable {
    let published: String?
    let content: String?
    
    init(published: String?, content: String?) {
        self.published = published
        self.content = content
    }
}
