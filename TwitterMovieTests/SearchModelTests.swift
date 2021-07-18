//
//  SearchModelTests.swift
//  TwitterMovieTests
//
//  Created by Shalom Friss on 7/17/21.
//

import XCTest
@testable import TwitterMovie

class SearchModelTests: XCTestCase {
    var searchModel:SearchModelInterface?
    
    override func setUpWithError() throws {
        let jsonString = TestUtil.readJSONFromFile(fileName: "TestData")
        let jsonData = jsonString?.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let results = try! decoder.decode(ResultsVO.self, from: jsonData!)
        
        searchModel = SearchModel()
        searchModel?.results = results
    }
    
    override func tearDownWithError() throws {
        searchModel = nil
    }
    
    func testNormalMovieCount() throws {
        XCTAssertEqual(searchModel?.resultRows.count, 20)
    }

    func testFilteredBasedOnUniqueBodyText() throws {
        searchModel?.filterResults(for: "three-part documentary")
        XCTAssertEqual(searchModel?.resultRows.count, 1)
    }
    
    func testFilteredBasedOnUniqueTitleText()  throws {
        searchModel?.filterResults(for: "The Story of Harry Potter")
        XCTAssertEqual(searchModel?.resultRows.count, 1)
    }
    
    func testFilteredShouldMatchAll()  throws {
        searchModel?.filterResults(for: "Harry Potter")
        XCTAssertEqual(searchModel?.resultRows.count, 20)
    }
    
    func testFilteredShouldMatchNone()  throws {
        searchModel?.filterResults(for: "should not match")
        XCTAssertEqual(searchModel?.resultRows.count, 0)
    }
    
    func testFilteredShouldResetToAllAfterMatch()  throws {
        searchModel?.filterResults(for: "The Story of Harry Potter")
        XCTAssertEqual(searchModel?.resultRows.count, 1)
        
        searchModel?.filterResults(for: "")
        XCTAssertEqual(searchModel?.resultRows.count, 20)
    }
    
    func testMatchContent() {
        searchModel?.filterResults(for: "Harry Potter and the Chamber of Secrets")
        XCTAssertEqual(searchModel?.resultRows.count, 1)
        
        let result = searchModel?.resultRows[0]
        XCTAssertEqual(result?.popularity, 55.517)
        XCTAssertEqual(result?.voteCount, 14019)
        XCTAssertEqual(result?.video, false)
        XCTAssertEqual(result?.posterPath, "/sdEOH0992YZ0QSxgXNIGLq1ToUi.jpg")
        XCTAssertEqual(result?.id, 672)
        XCTAssertEqual(result?.adult, false)
        XCTAssertEqual(result?.backdropPath, "/bvRnPaai6JL7XHF4K6414DdSHro.jpg")
        XCTAssertEqual(result?.originalLanguage, "en")
        XCTAssertEqual(result?.originalTitle, "Harry Potter and the Chamber of Secrets")
        XCTAssertEqual(result?.genreIDS, [12, 14])
        XCTAssertEqual(result?.title, "Harry Potter and the Chamber of Secrets")
        XCTAssertEqual(result?.voteAverage, 7.7)
        XCTAssertEqual(result?.overview, "Cars fly, trees fight back, and a mysterious house-elf comes to warn Harry Potter at the start of his second year at Hogwarts. Adventure and danger await when bloody writing on a wall announces: The Chamber Of Secrets Has Been Opened. To save Hogwarts will require all of Harry, Ron and Hermione’s magical abilities and courage.")
        XCTAssertEqual(result?.releaseDate, "2002-11-13")
        
    }
}
