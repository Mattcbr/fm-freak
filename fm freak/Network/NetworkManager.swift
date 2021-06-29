//
//  NetworkManager.swift
//  fm freak
//
//  Created by Matheus Queiroz on 6/29/21.
//

import Foundation
import Alamofire

class NetworkManager {
    
    static let sharedInstance = NetworkManager()
    
    private let pathBuilder = PathBuilder()
    
    // MARK: Requests
    
    func makeHipHopRequest(completion: @escaping (Swift.Result<AlbumsRequestInfo, HttpRequestError>) -> Void) {
        getRequestForUrl(pathBuilder.hipHopURL) { result in
            completion(result)
        }
    }
    
    func getRequestForUrl<T>(_ requestUrl: String, _ completion: @escaping (Swift.Result<T, HttpRequestError>) -> Void) where T : Codable {

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
}
