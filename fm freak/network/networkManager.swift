//
//  networkManager.swift
//  fm freak
//
//  Created by Matheus Queiroz on 6/29/21.
//

import Foundation

class networkManager {
    
    // MARK: Authentication Constants
    private let apiKey = "2bba18237e90a8fcd255bc33ea65b169"
    
    // MARK: URL Constants
    private let baseURL = "http://ws.audioscrobbler.com/2.0/"
    private let jsonSuffix = "&format=json"
    
    func makeHipHopURL() {
        let parameters = "?method=tag.gettopalbums&tag=hiphop&api_key=\(apiKey)"
        let fullUrl = makeFullUrl(withParameters: parameters)
        print(fullUrl)
    }
    
    private func makeFullUrl(withParameters params: String) -> String {
        return baseURL+params+jsonSuffix
    }
}
