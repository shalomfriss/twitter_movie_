//
//  NetworkManager.swift
//  TwitterMovie
//
//  Created by Shalom Friss on 7/17/21.
//

import Foundation
import UIKit

enum NetworkError: Error {
    case genericError
    case badURL
    case emptyResponse
    case emptyData
    case parseError
    case networkError
}

protocol NetworkManagerProtocol {
    func searchForMovie(searchTerm:String, completion: @escaping (Result<ResultsVO, NetworkError>) -> Void)
}

/// NetworkManager handles all network calls, caching and JSON serialization and deserialization
class NetworkManager:NetworkManagerProtocol {
    
    //MARK:- variables
    let cacheSizeMemory = 500*1024*1024
    let cacheSizeDisk = 0
    let cache:URLCache
    
    /// Shared class variable
    public static let shared:NetworkManager = NetworkManager()
    
    
    //MARK:- initialization
    init() {
        cache = URLCache(memoryCapacity: cacheSizeMemory, diskCapacity: cacheSizeDisk, diskPath: "nsurlcache")
    }
    
    //MARK:- Network calls
    /// Search for a movie
    /// - Parameters:
    ///   - searchTerm: String - The term to search for
    ///   - completion: Result<ResultsVO, NetworkError>
    public func searchForMovie(searchTerm:String, completion: @escaping (Result<ResultsVO, NetworkError>) -> Void) {
        let urlString = String(format: Paths.search.rawValue, Constants.api_key.rawValue, searchTerm)
        
        //Create the url
        guard let escapedString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed), let url = URL(string: escapedString) else {
            completion(.failure(NetworkError.badURL))
            return
        }
        
        let request = URLRequest(url: url)
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            
            //Check the cache
            if let cachedData = self?.cache.cachedResponse(for: request)?.data {
                do {
                    let decoder = JSONDecoder()
                    let results =  try decoder.decode(ResultsVO.self, from: cachedData)
                    completion(.success(results))
                } catch {
                    completion(.failure(NetworkError.parseError))
                }
            } else {    //Nothing in cache, fetch live data
                let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                    
                    //Check for an error
                    if let _ = error {
                        completion(.failure(NetworkError.badURL))
                        return
                    }
                    
                    guard let theResponse = response as? HTTPURLResponse else {
                        completion(.failure(NetworkError.emptyResponse))
                        return
                    }
                    
                    if(theResponse.statusCode < 200 || theResponse.statusCode > 299) {
                        completion(.failure(NetworkError.networkError))
                    }
                    
                    guard let theData = data else {
                        completion(.failure(NetworkError.emptyData))
                        return
                    }
                    
                    //Store response in cache
                    let cachedData = CachedURLResponse(response: theResponse, data: theData)
                    self?.cache.storeCachedResponse(cachedData, for: request)
                    
                    
                    do {
                        //Decode codable and respond
                        let decoder = JSONDecoder()
                        let results =  try decoder.decode(ResultsVO.self, from: theData)
                        completion(.success(results))
                    } catch {
                        completion(.failure(NetworkError.parseError))
                    }
                    
                }
                task.resume()
            }
        }
    }
    
    //MARK:- Network calls
    /// load the movie poster specified
    /// - Parameters:
    ///   - searchTerm: String - The image to load
    ///   - completion: Result<UIImage, NetworkError>
    public func loadMoviePoster(posterPath:String, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        let urlString = String(format: Paths.poster.rawValue, posterPath)
        
        //Create the url
        guard let escapedString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed), let url = URL(string: escapedString) else {
            completion(.failure(NetworkError.badURL))
            return
        }
        
        let request = URLRequest(url: url)
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            
            //Check the cache
            if let cachedData = self?.cache.cachedResponse(for: request)?.data, let image = UIImage(data: cachedData) {
                completion(.success(image))
            } else {    //Nothing in cache, fetch live data
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    
                    //Check for an error
                    if let _ = error {
                        completion(.failure(NetworkError.badURL))
                        return
                    }
                    
                    guard let theResponse = response as? HTTPURLResponse else {
                        completion(.failure(NetworkError.emptyResponse))
                        return
                    }
                    
                    if(theResponse.statusCode < 200 || theResponse.statusCode > 299) {
                        completion(.failure(NetworkError.networkError))
                    }
                    
                    guard let theData = data, let image = UIImage(data: theData) else {
                        completion(.failure(NetworkError.emptyData))
                        return
                    }
                    
                    let cachedData = CachedURLResponse(response: theResponse, data: theData)
                    self?.cache.storeCachedResponse(cachedData, for: request)
                    
                    completion(.success(image))
                    
                }
                task.resume()
            }
        }
    }
    
    
    
}
