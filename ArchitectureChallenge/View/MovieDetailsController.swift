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
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieGenres: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        movieTitle.text = movie?.title
        movieGenres.text = getMovieGenresString(genres: movie?.genres ?? [])
    }
    
    
    func getMovieGenresString (genres: [Genres]) -> String{
        return genres.reduce("", { (result: String, item: Genres) -> String in
            var aux: String = ""
            if genres.last?.id != item.id {aux = ", "}
            
            return result + item.name! + aux
        })
    }


}
