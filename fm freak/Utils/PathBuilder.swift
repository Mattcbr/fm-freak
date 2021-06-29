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
    
    var hipHopURL: String {
        let parameters = "?method=tag.gettopalbums&tag=hiphop&api_key=\(apiKey)&page=1"
        return makeFullUrl(withParameters: parameters)
    }
    
    // MARK: Making Full URL
    private func makeFullUrl(withParameters params: String) -> String {
        return baseURL+params+jsonSuffix
    }
}