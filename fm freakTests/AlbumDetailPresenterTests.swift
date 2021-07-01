//
//  AlbumDetailPresenterTests.swift
//  fm freakTests
//
//  Created by Matheus Queiroz on 6/30/21.
//

import XCTest
@testable import fm_freak

class AlbumDetailPresenterTests: XCTestCase {

    private var presenter: AlbumDetailPresenter<MockAlbumDetailView>?
    private var view = MockAlbumDetailView()
    private var networkManager: MockNetworkManager?
    private var databaseManager = MockDatabaseManager()
    private let utils = Utils()
    
    override func setUp() {
        
        networkManager = MockNetworkManager()
        presenter = AlbumDetailPresenter(networkManager: networkManager!, databaseManager: databaseManager)
        presenter?.attachView(view)
    }

    override func tearDownWithError() throws {
        presenter?.detachView()
        presenter = nil
        networkManager = nil
    }

    func testRequestDetailsFromNetwork_success() {
        //Given
        networkManager?.expectedResult = Result<Any, NetworkManager.HttpRequestError>.success((Any).self)
        
        //When
        presenter?.requestDetails(forAlbum:"testAlbum", artistName: "testArtist")
        
        //Then
        XCTAssertTrue(view.showAlbumDetailCalled)
        XCTAssertFalse(view.showErrorCalled)
    }
    
    func testRequestDetailsFromNetwork_failure() {
        //Given
        networkManager?.expectedResult = Result<Any, NetworkManager.HttpRequestError>.failure(.decoding)
        
        //When
        presenter?.requestDetails(forAlbum:"testAlbum", artistName: "testArtist")
        
        //Then
        XCTAssertTrue(view.showErrorCalled)
        XCTAssertFalse(view.showAlbumDetailCalled)
    }
    
    func testRequestDetailsFromDatabase_success() {
        //Given
        databaseManager.expectedResult = Result<Any, NetworkManager.HttpRequestError>.success((Any).self)
        
        //When
        presenter?.requestDetails(forAlbum:"testDBAlbum", artistName: "testDBArtist")
        
        //Then
        XCTAssertTrue(view.showAlbumDetailCalled)
        XCTAssertFalse(view.showErrorCalled)
    }
    
    func testSanitizeString_spacedString() {
        //Given
        let testString = "Test String"
        let expectedString = "Test%20String"
        
        //When
        let resultString = presenter?.sanitizeStringBeforeRequest(stringToSanitize: testString)
        
        //Then
        XCTAssertEqual(resultString, expectedString)
    }
    
    func testSanitizeString_notSpacedString() {
        //Given
        let testString = "TestString"
        
        //When
        let resultString = presenter?.sanitizeStringBeforeRequest(stringToSanitize: testString)
        
        //Then
        XCTAssertEqual(resultString, testString)
    }
    
    func testAddAlbumToDatabase_sucess() {
        //Given
        databaseManager.expectedResult = Result<Any, NetworkManager.HttpRequestError>.success((Any).self)
        
        //When
        let detailedAlbum = utils.mockedDBAlbumDetailedInfo
        let notInFavoritesAlbum = AlbumDetailedInfo(name: "testAlbumNotInFavorites",
                                                    artist: detailedAlbum.artist,
                                                    listeners: detailedAlbum.listeners,
                                                    tracks: detailedAlbum.tracks,
                                                    wiki: detailedAlbum.wiki)
        presenter?.selectedAlbum = notInFavoritesAlbum
        presenter?.didSelectFavoritesButton(withImage: nil)
        
        //Then
        XCTAssertTrue(view.showAddToFavoriteCompleteDialogCalled)
        XCTAssertTrue(view.showAddToFavoriteCompleteDialogCalledWasSuccessful ?? false)
    }
    
    func testAddAlbumToDatabase_failure() {
        //Given
        databaseManager.expectedResult = Result<Any, NetworkManager.HttpRequestError>.failure(.decoding)
        
        //When
        let detailedAlbum = utils.mockedDBAlbumDetailedInfo
        let notInFavoritesAlbum = AlbumDetailedInfo(name: "testAlbumNotInFavorites",
                                                    artist: detailedAlbum.artist,
                                                    listeners: detailedAlbum.listeners,
                                                    tracks: detailedAlbum.tracks,
                                                    wiki: detailedAlbum.wiki)
        presenter?.selectedAlbum = notInFavoritesAlbum
        presenter?.didSelectFavoritesButton(withImage: nil)
        
        //Then
        XCTAssertTrue(view.showAddToFavoriteCompleteDialogCalled)
        XCTAssertFalse(view.showAddToFavoriteCompleteDialogCalledWasSuccessful ?? true)
    }
    
    func testRemoveAlbumFromDatabase_sucess() {
        //Given
        databaseManager.expectedResult = Result<Any, NetworkManager.HttpRequestError>.success((Any).self)
        
        //When
        presenter?.selectedAlbum = utils.mockedDBAlbumDetailedInfo
        presenter?.didSelectFavoritesButton(withImage: nil)
        
        //Then
        XCTAssertTrue(view.showRemoveFromFavoriteCompleteDialogCalled)
        XCTAssertTrue(view.showRemoveFromFavoriteCompleteDialogCalledWasSuccessful ?? false)
    }
    
    func testRemoveAlbumFromDatabase_failure() {
        //Given
        databaseManager.expectedResult = Result<Any, NetworkManager.HttpRequestError>.failure(.decoding)
        
        //When
        presenter?.selectedAlbum = utils.mockedDBAlbumDetailedInfo
        presenter?.didSelectFavoritesButton(withImage: nil)
        
        //Then
        XCTAssertTrue(view.showRemoveFromFavoriteCompleteDialogCalled)
        XCTAssertFalse(view.showRemoveFromFavoriteCompleteDialogCalledWasSuccessful ?? true)
    }
}

private class MockAlbumDetailView: AlbumDetailView {
    
    var showAlbumDetailCalled: Bool = false
    var showErrorCalled: Bool = false
    var showAddToFavoriteCompleteDialogCalled: Bool = false
    var showAddToFavoriteCompleteDialogCalledWasSuccessful: Bool?
    var showRemoveFromFavoriteCompleteDialogCalled: Bool = false
    var showRemoveFromFavoriteCompleteDialogCalledWasSuccessful: Bool?
    
    func showAlbumDetail(forAlbum album: AlbumDetailedInfo) {
        showAlbumDetailCalled = true
    }
    
    func showError(_ error: Error?) {
        showErrorCalled = true
    }
    
    func showAddToFavoriteCompleteDialog(wasSuccessful: Bool) {
        showAddToFavoriteCompleteDialogCalled = true
        showAddToFavoriteCompleteDialogCalledWasSuccessful = wasSuccessful
    }
    
    func showRemoveFromFavoriteCompleteDialog(wasSuccessful: Bool) {
        showRemoveFromFavoriteCompleteDialogCalled = true
        showRemoveFromFavoriteCompleteDialogCalledWasSuccessful = wasSuccessful
    }
}
