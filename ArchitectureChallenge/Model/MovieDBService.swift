//
//  MovieDBService.swift
//  ArchitectureChallenge
//
//  Created by Rovane Moura on 14/08/19.
//  Copyright © 2019 Vitor Demenighi. All rights reserved.
//

import Foundation

class MovieDBService {
    
    // Como os metodos de requisicao sao assincronos, é necessário usar uma funcao callback para obter o retorno.
    func getNowPlayingMovies(callBack: @escaping ([Movie]?, Error?) -> () ) {
    
        if let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=79bb37b9869aa0ed97dc7a23c93d0829&language=en-US&page=1"){
            let task = URLSession.shared.dataTask(with: url) { (data, request, err) in
                
                if let error = err {
                    callBack(nil, error)
                } else if let dadosRetorno = data {
                    let moviesResult = try! JSONDecoder().decode(Movies.self, from: dadosRetorno)
                    let movies = moviesResult.results
                        callBack(movies, nil)
                }
            }
            task.resume()
        }
    }
    
    func getPopularMovies(callBack: @escaping ([Movie]?, Error?) -> () ) {
        
        if let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=79bb37b9869aa0ed97dc7a23c93d0829&language=en-US&page=1"){
            let task = URLSession.shared.dataTask(with: url) { (data, request, err) in
                
                if let error = err {
                    callBack(nil, error)
                } else if let dadosRetorno = data {
                    let moviesResult = try! JSONDecoder().decode(Movies.self, from: dadosRetorno)
                    let movies = moviesResult.results
                    callBack(movies, nil)
                }
            }
            task.resume()
        }
    }
    
    func getMovieDetails(movieId: Int, callBack: @escaping (MovieDetail?, Error?) -> () ) {
        
        if let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)?api_key=79bb37b9869aa0ed97dc7a23c93d0829&language=en-US"){
            let task = URLSession.shared.dataTask(with: url) { (data, request, err) in
                
                if let error = err {
                    callBack(nil, error)
                } else if let dadosRetorno = data {
                    let movieResult = try! JSONDecoder().decode(MovieDetail.self, from: dadosRetorno)
                    let movie = movieResult
                    callBack(movie, nil)
                }
            }
            task.resume()
        }
    }
    
    
}
