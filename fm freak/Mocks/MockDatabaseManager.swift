//
//  MockDatabaseManager.swift
//  fm freak
//
//  Created by Matheus Queiroz on 7/1/21.
//

import UIKit

class MockDatabaseManager: DatabaseManager {
    
    var expectedResult = Result<Any, NetworkManager.HttpRequestError>.success((Any).self)
    private let utils = Utils()
    
    override func getAllFavorites() -> [AlbumDetailedInfo] {
        return [utils.mockedDBAlbumDetailedInfo]
    }
    
    override func getSavedImage(forAlbums albums: [String?], _ completion: @escaping ([String : UIImage]) -> Void) {
        var imagesDict = [String : UIImage]()
        albums.forEach { album in
            if let albumUnwrapped = album {
                imagesDict[albumUnwrapped] = UIImage()
            }
        }
        
        completion(imagesDict)
    }
    
    override func addToFavorites(album: AlbumDetailedInfo, image: UIImage, _ completion: @escaping (Result<Bool, Error>) -> Void) {
        switch expectedResult {
        case .success:
            completion(.success(true))
        case .failure(let error):
            completion(.failure(error))
        }
    }
    
    override func removeFromFavorites(album: AlbumDetailedInfo, _ completion: @escaping (Result<Bool, Error>) -> Void) {
        switch expectedResult {
        case .success:
            completion(.success(true))
        case .failure(let error):
            completion(.failure(error))
        }
    }
}
