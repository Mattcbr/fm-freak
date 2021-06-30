//
//  PathBuilder.swift
//  fm freak
//
//  Created by Matheus Queiroz on 6/29/21.
//

import Foundation

class PathBuilder {
    // MARK: Authentication Constants
    private let apiKey = "2bba18237e90a8fcd255bc33ea65b169"
    
    // MARK: URL Constants
    private let baseURL = "http://ws.audioscrobbler.com/2.0/"
    private let jsonSuffix = "&format=json"
    
    // MARK: API Paths
    
    func getHipHopURL(forPage page: Int) -> String {
        let parameters = "?method=tag.gettopalbums&tag=hiphop&api_key=\(apiKey)&page=\(page)"
        return makeFullUrl(withParameters: parameters)
    }
    
    func getAlbumDetailURL(forAlbum albumName: String, artistName: String) -> String {
        let parameters = "?method=album.getInfo&api_key=\(apiKey)&artist=\(artistName)&album=\(albumName)"
        return makeFullUrl(withParameters: parameters)
    }
    
    // MARK: Making Full URL
    private func makeFullUrl(withParameters params: String) -> String {
        return baseURL+params+jsonSuffix
    }
}
