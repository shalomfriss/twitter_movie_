//
//  NetworkManagerMock.swift
//  TwitterMovieTests
//
//  Created by Shalom Friss on 7/17/21.
//

import Foundation
@testable import TwitterMovie

class NetworkManagerMock: NetworkManagerProtocol {
    func searchForMovie(searchTerm: String, completion: @escaping (Result<ResultsVO, NetworkError>) -> Void) {
        let result = ResultVO(popularity: 2, voteCount: 2, video: true, posterPath: "poster.jpg", id: 1, adult: true, backdropPath: "backdrop.jpg", originalLanguage: "english", originalTitle: "OriginalTitle", genreIDS: [1,2,3], title: "Title", voteAverage: 2.5, overview: "Overview", releaseDate: "1/2/21")
        
        let results = ResultsVO(page: 1, totalResults: 1, totalPages: 1, results: [result])
        completion(.success(results))
    }
}
