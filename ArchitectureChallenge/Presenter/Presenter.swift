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
    func setFiveNowPlayingMovies(moviesData: [MovieViewData])
    
    func showNowPlayingError(error: ServiceError)
    func showPopularError(error: ServiceError)
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
            
            if let movies = movies {
                for movie in movies{
                    moviesData.append(MovieViewData(
                        id: movie.id!,
                        vote_average: movie.vote_average!,
                        title: movie.title ?? "",
                        poster_path: movie.poster_path ?? "",
                        overview: movie.overview ?? ""))
                }
                
                self.listViewDelegate?.setNowPlayingMovies(moviesData: moviesData)
            } else {
                if let error = error {
                    self.listViewDelegate?.showNowPlayingError(error: error)
                }
            } 
        }
    }
    
    func getFiveNowPlayingMovies() {
        movieDBService.getNowPlayingMovies { (movies, error) in
            
            var moviesData: [MovieViewData] = []
            
            if let movies = movies {
                let firstFiveMovies = movies.prefix(5)
                
                for movie in firstFiveMovies {
                    moviesData.append(MovieViewData(
                        id: movie.id!,
                        vote_average: movie.vote_average!,
                        title: movie.title ?? "",
                        poster_path: movie.poster_path ?? "",
                        overview: movie.overview ?? ""))
                }
                
                 self.listViewDelegate?.setFiveNowPlayingMovies(moviesData: moviesData)
            } else {
                if let error = error {
                    self.listViewDelegate?.showNowPlayingError(error: error)
                }
            }
            
           
        }
    }
    
    func getPopularMoviesOrderedByVoteAverage() {
        
        movieDBService.getNowPlayingMovies { (movies, error) in
            
         
            let movieIDs = self.createArrayOfMovieIds(movies: movies)
            
            self.movieDBService.getPopularMovies { (movies, error) in
                
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
                    
                    moviesData = moviesData.sorted(by: { $0.vote_average > $1.vote_average })
                    
                    let result = self.removeSameIDMoviesFromList(movieIDs: movieIDs, moviesData: moviesData)
                    
                    self.listViewDelegate?.setPopularMovies(moviesData: result)
                } else {
                    if let error = error {
                        self.listViewDelegate?.showPopularError(error: error)
                    }
                }
            }
            
            
        }
        
    
    }
    
    func createArrayOfMovieIds(movies: [Movie]?) -> [Int]{
        var array_IDs: [Int] = []
        
        if let movies = movies {
            let firstFiveMovies = movies.prefix(5)
            for movie in firstFiveMovies {
                array_IDs.append(movie.id!)
            }
            return array_IDs
        }
        return []
    }
    
    func removeSameIDMoviesFromList(movieIDs: [Int], moviesData: [MovieViewData]) -> [MovieViewData] {
        
        // REFATORAR
        var resultMovieViewData: [MovieViewData] = []
        var aux: Bool = false
        
        for index in 0...moviesData.count-1 {
            
            aux = false
            
            for id in movieIDs {
                if moviesData[index].id == id { aux = true }
            }
            
            if !aux {
                resultMovieViewData.append(moviesData[index])
            }
        }
        
        return resultMovieViewData
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
