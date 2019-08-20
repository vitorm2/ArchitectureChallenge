//
//  ResultsViewController.swift
//  ArchitectureChallenge
//
//  Created by Rovane Moura on 20/08/19.
//  Copyright © 2019 Vitor Demenighi. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
    
    private let resultsPresenter = ResultsPresenter(movieDBService: MovieDBService())

    // Filmes filtrados pela busca
    var filteredMovies = [MovieViewData]()
    
    // @IBOutlet weak var searchResultsLabel: UILabel!
    @IBOutlet weak var resultsCollectionView: UICollectionView!
    
    // var resultsPresenter = ResultsPresenter()
    
    override func viewDidLoad() {
         
        super.viewDidLoad()
        
        resultsPresenter.setViewDelegate(resultsPresenterDelegate: self)
        
        resultsCollectionView.delegate = self
        resultsCollectionView.dataSource = self

    }

}

extension ResultsViewController : ResultsPresenterDelegate {
    
    func segueMovieDetails(movie: MovieDetail) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "movieDetailsSegue", sender: movie)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if let movie = sender as? MovieDetail {
            if let nextViewController = segue.destination as? MovieDetailsController {
                nextViewController.movie = movie
            }
        } else if let movies = sender as? [MovieViewData] {
            if let nextViewController = segue.destination as? SeeAllController {
                nextViewController.nowPlaying_moviesToDisplay = movies
            }
        }
    }
    
}

extension ResultsViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "nowPlayingCell", for: indexPath) as! NowPlayingCollectionViewCell

        cell.movieComponent.movieTitle.text = filteredMovies[indexPath.row].title
        cell.movieComponent.movieVoteAverage.text = String(filteredMovies[indexPath.row].vote_average)

        let imageURL = base_url + filteredMovies[indexPath.row].poster_path
        let url = URL(string: imageURL)

        cell.movieComponent.movieImage?.sd_setImage(with: url, placeholderImage: nil)

        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "collectionViewHeader", for: indexPath) as! HeaderCollectionReusableView
            headerView.headerTitle.text = "Showing \(filteredMovies.count) results"
            return headerView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        resultsPresenter.showMovieDetails(movieId: filteredMovies[indexPath.row].id)
    }
    
}

extension ResultsViewController : UISearchResultsUpdating {
    
    func searchBarIsEmpty() -> Bool {
        if let searchText = navigationItem.searchController?.searchBar.text {
            return searchText.isEmpty
        }
        return true
    }
    
    func isFiltering() -> Bool {
        if let searchCon = navigationItem.searchController {
            return searchCon.isActive && !searchBarIsEmpty()
        }
        return false
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if !searchBarIsEmpty() {
            resultsCollectionView.reloadData()
        }
        
    }
    
}
