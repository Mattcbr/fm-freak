//
//  DatabaseMapper.swift
//  fm freak
//
//  Created by Matheus Queiroz on 6/30/21.
//

import Foundation

class DatabaseMapper {
    func mapToDetailedInfo(cached: RealmDetailedAlbum) -> AlbumDetailedInfo {
        
        let wiki = Wiki(published: cached.wikiPublished, content: cached.wikiContent)
        
        var tracks = [Track]()
        if cached.tracksCount > 0 {
            for _ in 0...(cached.tracksCount-1) {
                tracks.append(Track(name: "cachedTrack", duration: 200))
            }
        }
        
        let tracksAsTracksArrayObject = TracksArray(track: tracks)
        
        let detailedInfoToReturn = AlbumDetailedInfo(name: cached.name,
                                                     artist: cached.artist,
                                                     listeners: cached.listeners,
                                                     tracks: tracksAsTracksArrayObject,
                                                     wiki: wiki)
        
        return detailedInfoToReturn
    }
    
    func mapToRealmDetailedInfo(object: AlbumDetailedInfo) -> RealmDetailedAlbum {
        let detailedInfoToReturn = RealmDetailedAlbum()
        
        detailedInfoToReturn.name = object.name
        detailedInfoToReturn.artist = object.artist
        detailedInfoToReturn.listeners = object.listeners
        detailedInfoToReturn.tracksCount = object.tracks?.track?.count ?? 0
        detailedInfoToReturn.wikiPublished = object.wiki?.published
        detailedInfoToReturn.wikiContent = object.wiki?.content
        
        return detailedInfoToReturn
    }
}
