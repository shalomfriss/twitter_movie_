//
//  SearchModel.swift
//  TwitterMovie
//
//  Created by Shalom Friss on 7/17/21.
//

import Foundation

protocol SearchModelInterface {
    var results:ResultsVO? { get set }
    var resultRows:[ResultVO] { get }
    func filterResults(for searchText: String)
}


class SearchModel: SearchModelInterface {
    
    //MARK:- Variables -
    public var results:ResultsVO?
    private var filterString = ""
    private var filteredResults = [ResultVO]()
    
    public var resultRows:[ResultVO] {
        get {
            if(filterString.isEmpty) {
                return results?.results ?? [ResultVO]()
            }
            return filteredResults
        }
    }
    
    //MARK:- Utils -
    
    /// Get filtered results for the given text
    /// - Parameter searchText: String - The text to search for
    /// - Returns: [ResultVO]
    public func filterResults(for searchText: String) {
        self.filterString = searchText
        let filtered = results?.results?.filter { result in
            return ( result.title?.lowercased().contains(searchText.lowercased()) ?? false ||
                    result.overview?.lowercased().contains(searchText.lowercased()) ?? false )
        }
        filteredResults = filtered ?? [ResultVO]()
    }
}
