//
//  SeeAllPresenter.swift
//  ArchitectureChallenge
//
//  Created by Vitor Demenighi on 19/08/19.
//  Copyright © 2019 Vitor Demenighi. All rights reserved.
//

import Foundation

protocol PresenterSeeAllDelegate: NSObjectProtocol {
    func segueMovieDetails(movie: MovieDetail)
}

class SeeAllPresenter {
    
    private let movieDBService : MovieDBService
    weak private var presenterSeeAllDelegate : PresenterSeeAllDelegate?
    
    
    init(movieDBService: MovieDBService) {
        self.movieDBService = movieDBService
    }
    
    func setViewDelegate(presenterSeeAllDelegate: PresenterSeeAllDelegate) {
        self.presenterSeeAllDelegate = presenterSeeAllDelegate
    }
    
    func showMovieDetails(movieId: Int) {
        movieDBService.getMovieDetails(movieId: movieId) { (movie, error) in
            if let movie = movie {
                self.presenterSeeAllDelegate?.segueMovieDetails(movie: movie)
            }
        }
    }
}



