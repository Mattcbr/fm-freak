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
    
    private var mockedWiki: Wiki
    private var mockedTrack: Track
    private var mockedTracksArray: TracksArray
    private var mockedAlbumDetailedInfo: AlbumDetailedInfo
    private var mockedAlbumFullInfo: AlbumFullInfo
    
    override init() {
        mockedImage = AlbumImage(text: "testUrl", size: "testSize")
        mockedArtist = Artist(name: "testName")
        mockedAlbum = Album(name: "testAlbum", artist: mockedArtist, image: [mockedImage])
        mockedAlbumsArray = AlbumsArray(album: [mockedAlbum])
        mockedAlbumRequestInfo = AlbumsRequestInfo(albums: mockedAlbumsArray)
        
        mockedWiki = Wiki(published: "testPublish", content: "testContent")
        mockedTrack = Track(name: "testTrack", duration: 10)
        mockedTracksArray = TracksArray(track: [mockedTrack])
        mockedAlbumDetailedInfo = AlbumDetailedInfo(name: "testName",
                                                    artist: "testArtist",
                                                    listeners: "testListeners",
                                                    tracks: mockedTracksArray,
                                                    wiki: mockedWiki)
        mockedAlbumFullInfo = AlbumFullInfo(album: mockedAlbumDetailedInfo)
    }
    
    override func makeHipHopRequest(forPage page: Int, completion: @escaping (Result<AlbumsRequestInfo, NetworkManager.HttpRequestError>) -> Void) {
        switch expectedResult {
        case .success:
            completion(.success(mockedAlbumRequestInfo))
        case .failure(_):
            completion(.failure(.decoding))
        }
    }
    
    override func makeDetailedAlbumRequest(forAlbum albumName: String, artistName: String, completion: @escaping (Result<AlbumFullInfo, NetworkManager.HttpRequestError>) -> Void) {
        switch expectedResult {
        case .success:
            completion(.success(mockedAlbumFullInfo))
        case .failure(_):
            completion(.failure(.decoding))
        }
    }
    
    override func requestImage(forAlbum album: Album, completion: @escaping ((String, UIImage)) -> Void) {
        completion(("Test", UIImage()))
    }
}
