//
//  Paths.swift
//  TwitterMovie
//
//  Created by Shalom Friss on 7/17/21.
//

import Foundation

/// Paths contains all the api paths in the app
enum Paths:String {
    case search = "https://api.themoviedb.org/3/search/movie?api_key=%@&query=%@"
    case poster = "https://image.tmdb.org/t/p/w600_and_h900_bestv2/%@"
}
