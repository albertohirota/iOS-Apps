//
//  MovieCell.swift
//  MovieApp2
//
//  Created by Alberto Hirota on 8/14/16.
//  Copyright © 2016 Alberto Hirota. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    //var webView: WKWebView!
    @IBOutlet weak var movieImg: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDescription: UILabel!
    @IBOutlet weak var movieUrl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(movies: Entity) {
        movieImg.image = movies.getMovieImg()
        movieTitle.text = movies.title
        movieDescription.text = movies.descriptionMovie
        movieUrl.text = movies.urlImdb
    }
    
    
}
