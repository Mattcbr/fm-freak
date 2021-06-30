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
    private var databaseManager = DatabaseManager.sharedInstance
    
    override func setUp() {
        
        networkManager = MockNetworkManager()
        presenter = AlbumDetailPresenter(networkManager: networkManager!, databaseManager: databaseManager)
        presenter?.attachView(view)
    }

    override func tearDownWithError() throws {
        presenter = nil
        networkManager = nil
    }

    func testRequestDetails_success() {
        //Given
        networkManager?.expectedResult = Result<Any, NetworkManager.HttpRequestError>.success((Any).self)
        
        //When
        presenter?.requestDetails(forAlbum:"testAlbum", artistName: "testArtist")
        
        //Then
        XCTAssertTrue(view.showAlbumDetailCalled)
        XCTAssertFalse(view.showErrorCalled)
    }
    
    func testRequestAlbuns_failure() {
        //Given
        networkManager?.expectedResult = Result<Any, NetworkManager.HttpRequestError>.failure(.decoding)
        
        //When
        presenter?.requestDetails(forAlbum:"testAlbum", artistName: "testArtist")
        
        //Then
        XCTAssertTrue(view.showErrorCalled)
        XCTAssertFalse(view.showAlbumDetailCalled)
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
}

private class MockAlbumDetailView: AlbumDetailView {
    
    var showAlbumDetailCalled: Bool = false
    var showErrorCalled: Bool = false
    var showAddToFavoriteCompleteDialogCalled: Bool = false
    var showRemoveFromFavoriteCompleteDialogCalled: Bool = false
    
    func showAlbumDetail(forAlbum album: AlbumDetailedInfo) {
        showAlbumDetailCalled = true
    }
    
    func showError(_ error: Error) {
        showErrorCalled = true
    }
    
    func showAddToFavoriteCompleteDialog(wasSuccessful: Bool) {
        showAddToFavoriteCompleteDialogCalled = true
    }
    
    func showRemoveFromFavoriteCompleteDialog(wasSuccessful: Bool) {
        showRemoveFromFavoriteCompleteDialogCalled = true
    }
}
