//
//  MovieDetailsController.swift
//  ArchitectureChallenge
//
//  Created by Vitor Demenighi on 15/08/19.
//  Copyright © 2019 Vitor Demenighi. All rights reserved.
//

import UIKit

class MovieDetailsController: UIViewController, MovieDetailsDelegate {
    
    var movie: MovieDetail?
    
    private let movieDetailsPresenter = MovieDetailsPresenter(movieDBService: MovieDBService())
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieGenres: UILabel!
    @IBOutlet weak var movieOverview: UITextView!
    @IBOutlet weak var movieVotesNumber: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieDetailsPresenter.setViewDelegate(movieDetailsDelegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        movieTitle.text = movie?.title
        movieGenres.text = getMovieGenresString(genres: movie?.genres ?? [])
        movieOverview.text = movie?.overview
        if let vote_average = movie?.vote_average {
            movieVotesNumber.text = String(vote_average)
        }
        
        movieDetailsPresenter.getMovieImage(imagePath: movie?.poster_path ?? "") { (data) in
            DispatchQueue.main.async {
                self.movieImage.image = UIImage(data: data!)
            }
        }
    }
    
    
    func getMovieGenresString (genres: [Genres]) -> String{
        return genres.reduce("", { (result: String, item: Genres) -> String in
            var aux: String = ""
            if genres.last?.id != item.id {aux = ", "}
            
            return result + item.name! + aux
        })
    }
    
    
}
