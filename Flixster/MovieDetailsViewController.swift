//
//  MovieDetailsViewController.swift
//  Flixster
//
//  Created by William Huynh on 10/18/19.
//  Copyright © 2019 wi2. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieDetailsViewController: UIViewController {

    //MARK: - Properties
    
    @IBOutlet weak var backdropView: UIImageView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    
    var movie: [String:Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // print(movie["title"])
        
        titleLabel.text = movie["title"] as? String
        titleLabel.sizeToFit()
        synopsisLabel.text = movie["overview"] as? String
        synopsisLabel.sizeToFit()
        
        let baseUrl = "https://image.tmdb.org/t/p/w780"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        
        let backdropPath = movie["backdrop_path"] as! String
        let backdropUrl = URL(string: "https://image.tmdb.org/t/p/w780" + backdropPath)
        
        posterView.af_setImage(withURL: posterUrl!)
        backdropView.af_setImage(withURL: backdropUrl!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Pass the selected movie to the detials view controller
        let trailerVC = segue.destination as! MovieTrailerViewController
        trailerVC.movie = movie
    }
    
    @IBAction func tapPoster(_ sender: Any) {
    }
    
}
