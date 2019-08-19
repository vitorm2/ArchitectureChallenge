//
//  SeeAllPresenter.swift
//  ArchitectureChallenge
//
//  Created by Vitor Demenighi on 19/08/19.
//  Copyright © 2019 Vitor Demenighi. All rights reserved.
//

import Foundation

class SeeAllPresenter {
    
    private let movieDBService : MovieDBService
    weak private var listViewDelegate : ListViewDelegate?
    
    
    init(movieDBService: MovieDBService) {
        self.movieDBService = movieDBService
    }
    
    func setViewDelegate(listViewDelegate: ListViewDelegate) {
        self.listViewDelegate = listViewDelegate
    }
}



