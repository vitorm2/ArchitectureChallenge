//
//  ResultsPresenter.swift
//  ArchitectureChallenge
//
//  Created by Rovane Moura on 20/08/19.
//  Copyright © 2019 Vitor Demenighi. All rights reserved.
//

import Foundation

protocol ResultsPresenterDelegate: NSObjectProtocol {
    func segueMovieDetails(movie: MovieDetail)
}

class ResultsPresenter {
    
    private let movieDBService : MovieDBService
    weak private var resultsPresenterDelegate : ResultsPresenterDelegate?
    
    init(movieDBService: MovieDBService) {
        self.movieDBService = movieDBService
    }
    
    func setViewDelegate(resultsPresenterDelegate: ResultsPresenterDelegate) {
        self.resultsPresenterDelegate = resultsPresenterDelegate
    }
    
    func showMovieDetails(movieId: Int) {
        movieDBService.getMovieDetails(movieId: movieId) { (movie, error) in
            if let movie = movie {
                self.resultsPresenterDelegate?.segueMovieDetails(movie: movie)
            }
        }
    }
    
}
