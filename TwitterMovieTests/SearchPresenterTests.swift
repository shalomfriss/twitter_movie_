//
//  SearchPresenterTests.swift
//  TwitterMovieTests
//
//  Created by Shalom Friss on 7/17/21.
//

import XCTest
@testable import TwitterMovie

class SearchPresenterTests: XCTestCase {

    let searchController = SearchViewController.getModule(networkManaget: NetworkManagerMock())
    var presenter:SearchPresenterInterface?
    
    override func setUpWithError() throws {
        presenter = searchController.presenter
        presenter?.searchForMovie(searchTerm: "test", completion: { result in
            
        })
    }
    
    func testSearchForMovie() throws {
        presenter?.searchForMovie(searchTerm: "test", completion: { [weak self] results in
            if let results = self?.presenter?.results {
                let item = results[0]

                XCTAssertEqual(results.count, 1)
                XCTAssertEqual(item.popularity, 2)
                XCTAssertEqual(item.voteCount, 2)
                XCTAssertEqual(item.video, true)
                XCTAssertEqual(item.posterPath, "poster.jpg")
                XCTAssertEqual(item.id, 1)
                XCTAssertEqual(item.backdropPath, "backdrop.jpg")
                XCTAssertEqual(item.originalLanguage, "english")
                XCTAssertEqual(item.originalTitle, "Overview")
                XCTAssertEqual(item.releaseDate, "1/2/21")
                
            } else {
                XCTFail()
            }
            
        })
    }

}
