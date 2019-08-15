//
//  Presenter.swift
//  ArchitectureChallenge
//
//  Created by Rovane Moura on 14/08/19.
//  Copyright © 2019 Vitor Demenighi. All rights reserved.
//

import Foundation

protocol ListViewDelegate: NSObjectProtocol  {
    
    func displayNowPlaying(movies: [Movie])
    func segueMovieDetails(movie: MovieDetail)
    
}

class Presenter {
    
    private let movieDBService : MovieDBService
    weak private var listViewDelegate : ListViewDelegate?
    
    init(movieDBService: MovieDBService) {
        self.movieDBService = movieDBService
    }
    
    func setViewDelegate(listViewDelegate: ListViewDelegate) {
        self.listViewDelegate = listViewDelegate
    }
    
    
    // Busca os filmes (através da classe de servico) e em seguida passa o resultado, através de um delegate, para a viewcontroller
    func showNowPlayingMovies() {
        movieDBService.getNowPlayingMovies { (movies, error) in
            self.listViewDelegate?.displayNowPlaying(movies: movies ?? [])
        }
    }
    
    func showPopularMovies() {
        movieDBService.getPopularMovies { (movies, error) in
            self.listViewDelegate?.displayNowPlaying(movies: movies ?? [])
        }
    }
    
    func showMovieDetails(movieId: Int) {
        movieDBService.getMovieDetails(movieId: movieId) { (movie, error) in
            if let movie = movie {
                self.listViewDelegate?.segueMovieDetails(movie: movie)
            }
            
        }
    }

    
}
