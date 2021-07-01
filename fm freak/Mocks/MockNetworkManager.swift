//
//  MockNetworkManager.swift
//  fm freak
//
//  Created by Matheus Queiroz on 6/30/21.
//

import UIKit

class MockNetworkManager: NetworkManager {
    
    var expectedResult = Result<Any, HttpRequestError>.success((Any).self)
    private let utils = Utils()
    
    override func makeHipHopRequest(forPage page: Int, completion: @escaping (Result<AlbumsRequestInfo, NetworkManager.HttpRequestError>) -> Void) {
        switch expectedResult {
        case .success:
            completion(.success(utils.mockedNetworkAlbumRequestInfo))
        case .failure(_):
            completion(.failure(.decoding))
        }
    }
    
    override func makeDetailedAlbumRequest(forAlbum albumName: String, artistName: String, completion: @escaping (Result<AlbumFullInfo, NetworkManager.HttpRequestError>) -> Void) {
        switch expectedResult {
        case .success:
            completion(.success(utils.mockedNetworkAlbumFullInfo))
        case .failure(_):
            completion(.failure(.decoding))
        }
    }
    
    override func requestImage(forAlbum album: Album, completion: @escaping ((String, UIImage)) -> Void) {
        completion(("Test", UIImage()))
    }
}
