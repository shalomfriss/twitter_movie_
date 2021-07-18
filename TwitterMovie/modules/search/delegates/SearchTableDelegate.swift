//
//  SearchTableDelegate.swift
//  TwitterMovie
//
//  Created by Shalom Friss on 7/17/21.
//
import Foundation
import UIKit

class SearchTableDelegate:NSObject {
    weak var presenter:SearchPresenter?
}

extension SearchTableDelegate:UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.results?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! SearchTableViewCell
        cell.body.text = ""
        cell.title.text = ""
        cell.theImage.image = UIImage(named: "PosterPlaceholder")
        
        if let result = presenter?.results?[indexPath.row] {
            cell.theImage.image = UIImage(named: "PosterPlaceholder")
            cell.title.text = result.title
            cell.body.text = result.overview
            if let posterPath = result.posterPath, let posterUrl = URL(string: String(format: Paths.poster.rawValue, posterPath)) {
                ImageCache.publicCache.load(url: posterUrl) { (resultImage) in
                    cell.theImage.image = resultImage
                }
            }
        }
        return cell
    }
}

extension SearchTableDelegate:UITableViewDelegate {
    //Currently unused
}
