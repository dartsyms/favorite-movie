//
//  MovieItem.swift
//  FavoriteMovie
//
//  Created by sanchez on 16.12.15.
//  Copyright © 2015 KOT LLC. All rights reserved.
//

import UIKit

struct MovieItem {
    
    var title = ""
    var id = ""
    var posterPath: String? = nil
    var releaseDate = ""
    var plot: String?
    var genre: String?
    var movieType = ""
    var writer: String?
    var actors: String?
    var director: String?
    var rate: String?
    
    init(dictionary: [String : AnyObject]) {
        title = dictionary["Title"] as! String
        id = dictionary["imdbID"] as! String
        posterPath = dictionary["Poster"] as? String ?? ""
        releaseDate = dictionary["Year"] as! String
        movieType = dictionary["Type"] as! String
        plot = dictionary["Plot"] as? String ?? ""
        genre = dictionary["Genre"] as? String ?? ""
        actors = dictionary["Actors"] as? String ?? ""
        writer = dictionary["Writer"] as? String ?? ""
        director = dictionary["Director"] as? String ?? ""
        rate = dictionary["Rate"] as? String ?? ""
    }
    
    static func moviesFromResults(results: [[String : AnyObject]]) -> [MovieItem] {
        
        var movies = [MovieItem]()
        
        for result in results {
            movies.append(MovieItem(dictionary: result))
        }
        
        return movies
    }
    
}
