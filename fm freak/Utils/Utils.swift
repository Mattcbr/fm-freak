//
//  Utils.swift
//  fm freak
//
//  Created by Matheus Queiroz on 6/29/21.
//

import Foundation

class Utils {
    let appClosingKey = "CloseCounter"
    let detailsSegueKey = "detailViewSegue"
    
    // MARK: Network Mocks
    var mockedNetworkImage: AlbumImage
    var mockedNetworkArtist: Artist
    var mockedNetworkAlbum: Album
    var mockedNetworkAlbumsArray: AlbumsArray
    var mockedNetworkAlbumRequestInfo: AlbumsRequestInfo
    
    var mockedNetworkWiki: Wiki
    var mockedNetworkTrack: Track
    var mockedNetworkTracksArray: TracksArray
    var mockedNetworkAlbumDetailedInfo: AlbumDetailedInfo
    var mockedNetworkAlbumFullInfo: AlbumFullInfo
    
    // MARK: Database Mocks
    
    var mockedDBAlbumImage: AlbumImage
    var mockedDBArtist: Artist
    var mockedDBAlbum: Album
    var mockedDBAlbumsArray: AlbumsArray
    var mockedDBAlbumRequestInfo: AlbumsRequestInfo
    
    var mockedDBWiki: Wiki
    var mockedDBTrack: Track
    var mockedDBTracksArray: TracksArray
    var mockedDBAlbumDetailedInfo: AlbumDetailedInfo
    var mockedDBAlbumFullInfo: AlbumFullInfo
    
    init() {
        
        // Initing network mocks
        mockedNetworkImage = AlbumImage(text: "testUrl", size: "testSize")
        mockedNetworkArtist = Artist(name: "testName")
        mockedNetworkAlbum = Album(name: "testAlbum", artist: mockedNetworkArtist, image: [mockedNetworkImage])
        mockedNetworkAlbumsArray = AlbumsArray(album: [mockedNetworkAlbum])
        mockedNetworkAlbumRequestInfo = AlbumsRequestInfo(albums: mockedNetworkAlbumsArray)
        
        mockedNetworkWiki = Wiki(published: "testPublish", content: "testContent")
        mockedNetworkTrack = Track(name: "testTrack", duration: 10)
        mockedNetworkTracksArray = TracksArray(track: [mockedNetworkTrack])
        mockedNetworkAlbumDetailedInfo = AlbumDetailedInfo(name: "testName",
                                                    artist: "testArtist",
                                                    listeners: "testListeners",
                                                    tracks: mockedNetworkTracksArray,
                                                    wiki: mockedNetworkWiki)
        mockedNetworkAlbumFullInfo = AlbumFullInfo(album: mockedNetworkAlbumDetailedInfo)
        
        // Initing db mocks
        mockedDBAlbumImage = AlbumImage(text: "testDBUrl", size: "testDBSize")
        mockedDBArtist = Artist(name: "testDBName")
        mockedDBAlbum = Album(name: "testDBAlbum", artist: mockedDBArtist, image: [mockedDBAlbumImage])
        mockedDBAlbumsArray = AlbumsArray(album: [mockedDBAlbum])
        mockedDBAlbumRequestInfo = AlbumsRequestInfo(albums: mockedDBAlbumsArray)
        
        mockedDBWiki = Wiki(published: "testDBPublish", content: "testDBContent")
        mockedDBTrack = Track(name: "testDBTrack", duration: 10)
        mockedDBTracksArray = TracksArray(track: [mockedDBTrack])
        mockedDBAlbumDetailedInfo = AlbumDetailedInfo(name: "testDBAlbum",
                                        artist: "testDBArtist",
                                        listeners: "testDBListeners",
                                        tracks: mockedDBTracksArray,
                                        wiki: mockedDBWiki)
        mockedDBAlbumFullInfo = AlbumFullInfo(album: mockedDBAlbumDetailedInfo)
    }
    
}
