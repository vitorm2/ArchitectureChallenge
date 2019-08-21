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
    func updateFilteredMovies(movies: [MovieViewData])
    func showSearchError(error: ServiceError)
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
    
    func searchMovies(str: String) {
        
        let formatedStr = str.replacingOccurrences(of: " ", with: "%20")
        
        movieDBService.searchMovies(str: formatedStr) { (movies, error) in
            
            var moviesData: [MovieViewData] = []
            if let movies = movies {
                for movie in movies {
                    moviesData.append(MovieViewData(
                        id: movie.id!,
                        vote_average: movie.vote_average!,
                        title: movie.title ?? "",
                        poster_path: movie.poster_path ?? "",
                        overview: movie.overview ?? ""))
                }
                self.resultsPresenterDelegate?.updateFilteredMovies(movies: moviesData)
            } else {
                if let error = error {
                    self.resultsPresenterDelegate?.showSearchError(error: error)
                }
            }
        }
    }
}
