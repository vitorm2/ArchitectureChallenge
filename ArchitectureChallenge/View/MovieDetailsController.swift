//
//  MovieDetailsController.swift
//  ArchitectureChallenge
//
//  Created by Vitor Demenighi on 15/08/19.
//  Copyright © 2019 Vitor Demenighi. All rights reserved.
//

import UIKit

class MovieDetailsController: UIViewController {
    
    var movie: MovieDetail?
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieGenres: UILabel!
    @IBOutlet weak var movieOverview: UITextView!
    @IBOutlet weak var movieVotesNumber: UILabel!
//
//    var closure: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let navCon = navigationController {
            navigationController?.navigationBar.isHidden = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        movieTitle.text = movie?.title
        movieGenres.text = getMovieGenresString(genres: movie?.genres ?? [])
        movieOverview.text = movie?.overview
        if let vote_average = movie?.vote_average {
            movieVotesNumber.text = String(vote_average)
        }
        
        let imageURL = base_url + (movie?.poster_path)!
        let url = URL(string: imageURL)
        
        movieImage.sd_setImage(with: url, placeholderImage: nil)
        
        navigationItem.largeTitleDisplayMode = .never
        
        
//        closure = {
//            print(self)
//        }
    }
    
    
    func getMovieGenresString (genres: [Genres]) -> String{
        return genres.reduce("", { (result: String, item: Genres) -> String in
            var aux: String = ""
            
            print(self)
            
            if genres.last?.id != item.id {aux = ", "}
            
            return result + item.name! + aux
        })
    }
    
        
}
