//
//  NetworkManager.swift
//  fm freak
//
//  Created by Matheus Queiroz on 6/29/21.
//

import Foundation
import Alamofire
import AlamofireImage

class NetworkManager {
    
    static let sharedInstance = NetworkManager()
    
    private let pathBuilder = PathBuilder()
    
    // MARK: Requests
    
    func makeHipHopRequest(forPage page: Int, completion: @escaping (Swift.Result<AlbumsRequestInfo, HttpRequestError>) -> Void) {
        getRequestForUrl(pathBuilder.getHipHopURL(forPage: page)) { result in
            completion(result)
        }
    }
    
    func makeDetailedAlbumRequest(forAlbum albumName: String, artistName: String, completion: @escaping (Swift.Result<AlbumFullInfo, HttpRequestError>) -> Void) {
        getRequestForUrl(pathBuilder.getAlbumDetailURL(forAlbum: albumName, artistName: artistName)) { result in
            completion(result)
        }
    }
    
    private func getRequestForUrl<T>(_ requestUrl: String, _ completion: @escaping (Swift.Result<T, HttpRequestError>) -> Void) where T : Codable {

        Alamofire.request(requestUrl).responseJSON { response in
            switch response.result {
            case .success:
                guard let data = response.data else {return}
                let decoder = JSONDecoder()
                do {
                    let decoded = try decoder.decode(T.self, from: data)
                    completion(.success(decoded))
                } catch let error {
                    print("Decoding Error:\(error.localizedDescription)")
                    completion(.failure(.decoding))
                }
            case .failure(let error):
                print("Error:\(error.localizedDescription)")
                completion(.failure(.unavailable))
            }
        }
    }
    
    enum HttpRequestError: Error {
        case unavailable
        case decoding
    }
    
    func requestImage(forAlbum album: Album, completion: @escaping (_ imageTuple: (String, UIImage)) -> Void) {
        if let addressToRequest = album.image?.last?.text {
            Alamofire.request(addressToRequest).responseImage { response in
                if let image = response.result.value, let albumName = album.name {
                    completion((albumName, image))
                }
            }
        }
    }
}
