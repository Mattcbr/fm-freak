//
//  MockNetworkManager.swift
//  fm freak
//
//  Created by Matheus Queiroz on 6/30/21.
//

import UIKit

class MockNetworkManager: NetworkManager {
    
    var expectedResult = Result<Any, HttpRequestError>.success((Any).self)
    
    //MARK: Mock models
    
    private var mockedImage: AlbumImage
    private var mockedArtist: Artist
    private var mockedAlbum: Album
    private var mockedAlbumsArray: AlbumsArray
    private var mockedAlbumRequestInfo: AlbumsRequestInfo
    
    override init() {
        mockedImage = AlbumImage(text: "testUrl", size: "testSize")
        mockedArtist = Artist(name: "testName")
        mockedAlbum = Album(name: "testAlbum", artist: mockedArtist, image: [mockedImage])
        mockedAlbumsArray = AlbumsArray(album: [mockedAlbum])
        mockedAlbumRequestInfo = AlbumsRequestInfo(albums: mockedAlbumsArray)
    }
    
    override func makeHipHopRequest(forPage page: Int, completion: @escaping (Result<AlbumsRequestInfo, NetworkManager.HttpRequestError>) -> Void) {
        switch expectedResult {
        case .success:
            completion(.success(mockedAlbumRequestInfo))
        case .failure(_):
            completion(.failure(.decoding))
        }
    }
    
    override func requestImage(forAlbum album: Album, completion: @escaping ((String, UIImage)) -> Void) {
        completion(("Test", UIImage()))
    }
}
