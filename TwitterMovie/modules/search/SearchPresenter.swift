//
//  SearchPresenter.swift
//  TwitterMovie
//
//  Created by Shalom Friss on 7/17/21.
//

import UIKit

protocol SearchPresenterInterface {
    func searchForMovie(searchTerm:String, completion: @escaping (Result<ResultsVO, NetworkError>) -> Void)
    func filterResults(for searchText: String)
    var results:[ResultVO]? { get }
}

class SearchPresenter:SearchPresenterInterface {
    
    // MARK: - Private properties -
    
    private unowned let _view: UIViewController
    private var _model: SearchModelInterface
    private var filterString = ""
    private var filteredResults = [ResultVO]()
    private var _networkManager: NetworkManagerProtocol?
    
    public var results:[ResultVO]? {
        get {
             return _model.resultRows
        }
    }
    
    // MARK: - Lifecycle -
    
    init(view: UIViewController, model: SearchModelInterface, networkManager:NetworkManagerProtocol) {
        _view = view
        _model = model
        _networkManager = networkManager
    }
    
    //MARK:- Utils -
    
    /// Search for a movie term
    /// - Parameter term: String - the term to search for
    public func searchForMovie(searchTerm:String, completion: @escaping (Result<ResultsVO, NetworkError>) -> Void) {
        _networkManager?.searchForMovie(searchTerm: searchTerm, completion: { [weak self] result in
            switch result {
            case .success(let data):
                self?._model.results = data
                DispatchQueue.main.async {
                    completion(.success(data))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        })
    }
    
    
    /// Get filtered results for the given text
    /// - Parameter searchText: String - The text to search for
    /// - Returns: [ResultVO]
    public func filterResults(for searchText: String) {
        _model.filterResults(for: searchText)
        
    }
}
