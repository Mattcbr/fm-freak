//
//  DatabaseManager.swift
//  fm freak
//
//  Created by Matheus Queiroz on 6/30/21.
//

import Foundation
import RealmSwift

class DatabaseManager {
    
    static let sharedInstance = DatabaseManager()
    
    private var latestFavoritesArray = [AlbumDetailedInfo]()
    private var shouldUpdate = true
    private let mapper = DatabaseMapper()
    
    private func getDatabase() throws -> Realm {
        let configuration = Realm.Configuration(schemaVersion: UInt64(1.0),
                                                migrationBlock: nil,
                                                deleteRealmIfMigrationNeeded: false)
        
        return try Realm(configuration: configuration)
    }
    
    func getAllFavorites() -> [AlbumDetailedInfo] {
        if shouldUpdate {
            var convertedResultsArray = [AlbumDetailedInfo]()
            do {
                let realm = try getDatabase()
                let results = realm.objects(RealmDetailedAlbum.self)
                let resultsAsArray = Array(results)
                resultsAsArray.forEach { result in
                    let mappedToAlbumInfo = mapper.mapToDetailedInfo(cached: result)
                    convertedResultsArray.append(mappedToAlbumInfo)
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            latestFavoritesArray = convertedResultsArray
            shouldUpdate = false
            return convertedResultsArray
        } else {
            return latestFavoritesArray
        }
    }
    
    func addToFavorites(album: AlbumDetailedInfo, _ completion: @escaping (Swift.Result<Bool, Error>) -> Void) {
        let cacheModel = mapper.mapToRealmDetailedInfo(object: album)
        do {
            let realm = try getDatabase()
            try realm.write {
                realm.add(cacheModel, update: .all)
            }
            completion(.success(true))
        } catch let error as NSError {
            completion(.failure(error))
        }
        shouldUpdate = true
    }
    
    func removeFromFavorites(album: AlbumDetailedInfo, _ completion: @escaping (Swift.Result<Bool, Error>) -> Void) {
        // Missing: Actually handle all the errors, maybe add completion blocks
        let cacheModel = mapper.mapToRealmDetailedInfo(object: album)
        do {
            let realm = try getDatabase()
            try realm.write {
                realm.delete(realm.objects(RealmDetailedAlbum.self).filter({$0.name == cacheModel.name}))
            }
            completion(.success(true))
        } catch let error as NSError {
            completion(.failure(error))
        }
        shouldUpdate = true
    }
}
