//
//  SearchViewController.swift
//  TwitterMovie
//
//  Created by Shalom Friss on 7/17/21.
//

import Foundation
import UIKit

class SearchViewController: UIViewController {
    
    //MARK:- Outlets -
    @IBOutlet weak var searchTable: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    
    let searchController = UISearchController(searchResultsController: nil)
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    // MARK: - Public properties -
    var presenter: SearchPresenterInterface!
    var searchTabledelegate:SearchTableDelegate = SearchTableDelegate()
    
    var isFiltering = false
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTable.dataSource = searchTabledelegate
        searchTable.delegate = searchTabledelegate
        searchTabledelegate.presenter = (presenter as? SearchPresenter)
        
        searchController.searchBar.placeholder = "Search"
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchTable.tableHeaderView = searchController.searchBar
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
        self.view.addSubview(activityIndicator)
        
    }
    
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        if(isFiltering == true) {
            searchController.searchBar.placeholder = "Search"
            searchButton.setTitle("Filter", for: .normal)
        } else {
            searchController.searchBar.placeholder = "Filter"
            searchButton.setTitle("Search", for: .normal)
        }
        isFiltering = !isFiltering

    }
    
    //MARK:- Module method -
    
    /// Static function to construct our MVP module and return the view controller
    /// - Returns: SearchViewController
    public static func getModule(networkManaget:NetworkManagerProtocol) -> SearchViewController {
        let searchStoryboard = UIStoryboard(name: "Search", bundle: nil)
        let searchViewController =  searchStoryboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        let searchModel = SearchModel()
        let searchPresenter = SearchPresenter(view: searchViewController, model: searchModel, networkManager: networkManaget)
        searchViewController.presenter = searchPresenter
        return searchViewController
    }
    
}


extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if(isFiltering) {
            guard let filterText = searchController.searchBar.text else { return }
            filterResults(filterText)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if(isFiltering) {
            return
        }
        
        self.activityIndicator.startAnimating()
        guard let searchText = searchController.searchBar.text else { return }
        searchController.searchBar.text = ""
        self.presenter.searchForMovie(searchTerm: searchText, completion: { [weak self] results in
                self?.activityIndicator.stopAnimating()
                self?.searchTable.reloadData()
        })
    }

    func filterResults(_ term:String) {
        presenter.filterResults(for: term)
        DispatchQueue.main.async {
            self.searchTable.reloadData()
        }
    }
    
}

