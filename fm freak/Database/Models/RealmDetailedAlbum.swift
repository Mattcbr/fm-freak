//
//  RealmDetailedAlbum.swift
//  fm freak
//
//  Created by Matheus Queiroz on 6/30/21.
//

import Foundation
import RealmSwift

class RealmDetailedAlbum: Object {
    @objc dynamic var name: String?
    @objc dynamic var artist: String?
    @objc dynamic var listeners: String?
    @objc dynamic var tracksCount: Int = 0
    @objc dynamic var wikiPublished: String?
    @objc dynamic var wikiContent: String?
    
    override static func primaryKey() -> String? {
        return "name"
    }
}
