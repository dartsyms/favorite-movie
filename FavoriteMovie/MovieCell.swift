//
//  MovieCell.swift
//  FavoriteMovie
//
//  Created by sanchez on 16.12.15.
//  Copyright © 2015 KOT LLC. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
    
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var moviePersonalDesc: UILabel!
    @IBOutlet weak var imdbLink: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        moviePoster.layer.cornerRadius = moviePoster.frame.size.width / 2
        moviePoster.clipsToBounds = true
    }
    
    func configureCell(movie: Movie) {
        moviePoster.image = movie.getMoviePosterImage()
        movieTitle.text = movie.title
        moviePersonalDesc.text = movie.personalDescription
        imdbLink.text = "http://www.imdb.com/title/\(movie.imdbId!)/"
    }
    
}
