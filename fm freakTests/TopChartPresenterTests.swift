//
//  TopChartPresenterTests.swift
//  fm freakTests
//
//  Created by Matheus Queiroz on 6/29/21.
//

import XCTest
@testable import fm_freak

class TopChartPresenterTests: XCTestCase {

    private var presenter: TopChartPresenter<MockTopChartView>?
    private var view = MockTopChartView()
    private var networkManager: MockNetworkManager?
    private var databaseManager = DatabaseManager.sharedInstance
    
    override func setUp() {
        
        networkManager = MockNetworkManager()
        presenter = TopChartPresenter(networkManager: networkManager!, databaseManager: databaseManager, isFavoritesScreen: false)
        presenter?.attachView(view)
    }

    override func tearDownWithError() throws {
        presenter = nil
        networkManager = nil
    }

    func testRequestAlbuns_success() {
        //Given
        networkManager?.expectedResult = Result<Any, NetworkManager.HttpRequestError>.success((Any).self)
        
        //When
        presenter?.requestAlbunsFromNetwork()
        
        //Then
        XCTAssertTrue(view.addNewAlbunsToArrayCalled)
        XCTAssertTrue(view.addNewImagesToDictionaryCalled)
    }
    
    func testRequestAlbuns_failure() {
        //Given
        networkManager?.expectedResult = Result<Any, NetworkManager.HttpRequestError>.failure(.decoding)
        
        //When
        presenter?.requestAlbunsFromNetwork()
        
        //Then
        XCTAssertTrue(view.showErrorCalled)
    }
    
    func testRequestMoreAlbuns() {
        //Given
        networkManager?.expectedResult = Result<Any, NetworkManager.HttpRequestError>.success((Any).self)
        
        //When
        presenter?.requestMoreAlbums()
        
        //Then
        XCTAssertTrue(view.addNewAlbunsToArrayCalled)
        XCTAssertTrue(view.addNewImagesToDictionaryCalled)
    }
    
}

private class MockTopChartView: TopChartView {
    
    var addNewAlbunsToArrayCalled: Bool = false
    var addNewImagesToDictionaryCalled: Bool = false
    var showErrorCalled: Bool = false
    
    func addNewAlbunsToArray(newAlbuns: [Album]) {
        addNewAlbunsToArrayCalled = true
    }
    
    func addNewImagesToDictionary(newImages: [String: UIImage]) {
        addNewImagesToDictionaryCalled = true
    }
    
    func showError(_ error: Error?) {
        showErrorCalled = true
    }
}
