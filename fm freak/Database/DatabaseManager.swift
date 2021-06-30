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
    
    func getSavedImage(forAlbums albums: [String?], _ completion: @escaping ([String: UIImage]) -> Void) {
        var albumsDict = [String: UIImage]()
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let dirPath = paths.first {
            albums.forEach { album in
                if let albumUnwrapped = album {
                    let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent("\(albumUnwrapped).png")
                    let image = UIImage(contentsOfFile: imageUrl.path)
                    
                    albumsDict[albumUnwrapped] = image
                }
            }
        }
        
        completion(albumsDict)
    }
    
    func addToFavorites(album: AlbumDetailedInfo, image: UIImage, _ completion: @escaping (Swift.Result<Bool, Error>) -> Void) {
        let cacheModel = mapper.mapToRealmDetailedInfo(object: album)
        do {
            // Saving to the Database
            let realm = try getDatabase()
            try realm.write {
                realm.add(cacheModel, update: .all)
            }
            
            // Saving image to disk
            if let data = image.jpegData(compressionQuality: 1), let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL {
                try data.write(to: directory.appendingPathComponent("\(album.name!).png")!) //Check this force cast
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
