//
//  Presenter.swift
//  ArchitectureChallenge
//
//  Created by Rovane Moura on 14/08/19.
//  Copyright © 2019 Vitor Demenighi. All rights reserved.
//

import Foundation

protocol ViewDelegate {
    
    func setSelectedMovie(title: String)
    
}

class Presenter : ViewDelegate {
    
    private let movieDBService : MovieDBService
    weak private var viewController : ViewController?
    
    init(movieDBService: MovieDBService) {
        self.movieDBService = movieDBService
    }
    
    func setViewDelegate(viewController: ViewController) {
        self.viewController = viewController
    }
    
    // View Delegate
    func setSelectedMovie(title: String) {
        movieDBService.getMovie(title: title) { [weak self] movie in
            
            if let movie = movie {
                self?.viewController?.setMovieDescription(desc: movie.description)
            }
            
        }
    }
    
}
