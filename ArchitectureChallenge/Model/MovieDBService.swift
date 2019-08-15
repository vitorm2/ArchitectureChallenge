//
//  MovieDBService.swift
//  ArchitectureChallenge
//
//  Created by Rovane Moura on 14/08/19.
//  Copyright © 2019 Vitor Demenighi. All rights reserved.
//

import Foundation

struct Movie {
    let title : String
    let description : String
}

class MovieDBService {
    
    let movies = [
        Movie(title: "Title1", description: "Desc1"),
        Movie(title: "Title2", description: "Desc2"),
        Movie(title: "Title3", description: "Desc3")
    ]
    
    func getMovie(title: String, callback: (Movie?) -> Void) {
        
        if let movie = movies.first(where: { movie in movie.title == title }) {
            callback(movie)
        } else {
            callback(nil)
        }
        
    }
    
}
