//
//  NetworkManager.swift
//  fm freak
//
//  Created by Matheus Queiroz on 6/29/21.
//

import UIKit
import Alamofire
import AlamofireImage

class NetworkManager {
    
    static let sharedInstance = NetworkManager()
    
    private let pathBuilder = PathBuilder()
    
    // MARK: Requests
    
    /**
     This makes a requests to the network for an specific hip hop chart page
     
     - Parameter page: The page that should be requested
     - Parameter completion: The callback that is called after the operations are completed
     */
    func makeHipHopRequest(forPage page: Int, completion: @escaping (Swift.Result<AlbumsRequestInfo, HttpRequestError>) -> Void) {
        getRequestForUrl(pathBuilder.getHipHopURL(forPage: page)) { result in
            completion(result)
        }
    }
    
    /**
     This makes a requests to the network for an specific album
     
     - Parameter albumName: The album that should be requested
     - Parameter artistName: The artist related to the album that should be requested
     - Parameter completion: The callback that is called after the operations are completed
     */
    func makeDetailedAlbumRequest(forAlbum albumName: String, artistName: String, completion: @escaping (Swift.Result<AlbumFullInfo, HttpRequestError>) -> Void) {
        getRequestForUrl(pathBuilder.getAlbumDetailURL(forAlbum: albumName, artistName: artistName)) { result in
            completion(result)
        }
    }
    
    /**
     This makes a requests to the network for an specific URL
     
     - Parameter requestUrl: The URL that should be requested
     - Parameter completion: The callback that is called after the operations are completed
     */
    private func getRequestForUrl<T>(_ requestUrl: String, _ completion: @escaping (Swift.Result<T, HttpRequestError>) -> Void) where T : Codable {

        Alamofire.AF.request(requestUrl).responseJSON { response in
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
    
    /**
     This makes a requests to the network for an specific image
     
     - Parameter album: The album for which the image should be requested
     - Parameter completion: The callback that is called after the operations are completed
     */
    func requestImage(forAlbum album: Album, completion: @escaping (_ imageTuple: (String, UIImage)) -> Void) {
        if let addressToRequest = album.image?.last?.text {
            Alamofire.AF.request(addressToRequest).responseImage { response in
                switch response.result {
                case .success(let image):
                    completion((album.name!, image))
                case .failure(let error):
                    //handle error
                    print("Error")
                }
            }
        }
    }
}
