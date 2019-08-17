//
//  Presenter.swift
//  ArchitectureChallenge
//
//  Created by Rovane Moura on 14/08/19.
//  Copyright © 2019 Vitor Demenighi. All rights reserved.
//

import Foundation

protocol ListViewDelegate: NSObjectProtocol  {

    func segueMovieDetails(movie: MovieDetail)
    func setNowPlayingMovies(moviesData: [MovieViewData])
    func setPopularMovies(moviesData: [MovieViewData])
    
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
    
    // Busca os filmes (através da classe de servico), em seguida pega os filmes e converte para o a struct MovieViewData e através de um delegate passa coleção para a viewcontroller
    func getNowPlayingMovies() {
        movieDBService.getNowPlayingMovies { (movies, error) in
            
            var moviesData: [MovieViewData] = []
            
            for movie in movies! {
                moviesData.append(MovieViewData(
                    id: movie.id!,
                    vote_average: movie.vote_average!,
                    title: movie.title ?? "",
                    poster_path: movie.poster_path ?? "",
                    overview: movie.overview ?? ""))
            }
            
            self.listViewDelegate?.setNowPlayingMovies(moviesData: moviesData)
        }
    }
    
    func getPopularMovies() {
        movieDBService.getPopularMovies { (movies, error) in
            
            var moviesData: [MovieViewData] = []
            
            for movie in movies! {
                moviesData.append(MovieViewData(
                    id: movie.id!,
                    vote_average: movie.vote_average!,
                    title: movie.title ?? "",
                    poster_path: movie.poster_path ?? "",
                    overview: movie.overview ?? ""))
            }
            
            self.listViewDelegate?.setPopularMovies(moviesData: moviesData)
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


struct MovieViewData {
    let id: Int
    let vote_average: Double
    let title: String
    let poster_path: String
    let overview: String
}
