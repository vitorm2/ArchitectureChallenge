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
    @IBOutlet weak var errorLayoutView: UIView!
    @IBOutlet weak var errorView: ErrorView!
    
    // var resultsPresenter = ResultsPresenter()
    
    override func viewDidLoad() {
         
        super.viewDidLoad()
        
        resultsPresenter.setViewDelegate(resultsPresenterDelegate: self)
        
        resultsCollectionView.delegate = self
        resultsCollectionView.dataSource = self
        
    }
    
   

}

extension ResultsViewController: ResultsPresenterDelegate {
    
    func segueMovieDetails(movie: MovieDetail) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "movieDetailsSegue", sender: movie)
        }
    }
    
    func updateFilteredMovies(movies: [MovieViewData]) {
        
        // Se o resultado da requisicao estiver vazio, mostra  mensagem de erro
        if movies.count == 0 {
            DispatchQueue.main.async {
                self.errorLayoutView.isHidden = false
                self.errorView.errorImage.image = UIImage(named: "searchNoMovie")
                self.errorView.errorTitle.text = "Oh snap!"
                self.errorView.errorDescription.text = "Looks like no movies match your search. Why don’t you search for another name?"
                self.errorView.errorButton.isHidden = true
            }
        } else {
            filteredMovies = movies
            DispatchQueue.main.async {
                self.errorLayoutView.isHidden = true
                self.resultsCollectionView.reloadData()
            }
        }
    }
    
    func showSearchError(error: ServiceError) {
        print(error.status_message ?? "")
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
            
            // Mostra o texto apenas quando tiver resultado da busca
            if filteredMovies.count == 0 {
                headerView.isHidden = true
            } else {
                headerView.isHidden = false
            }
            
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
    }
    
    
    
}

extension ResultsViewController : UISearchControllerDelegate {
    func didPresentSearchController(_ searchController: UISearchController) {
    }
    
    
}

extension ResultsViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
        if let text = searchBar.text  {
            // Permite pesquisar apenas palavras com 3 ou mais caracteres
            if text.count > 2 {
                resultsPresenter.searchMovies(str: text)
            }
        }
    }
    
    // Quando clicado o botao de cancelar, limpa a collection view e tira o layout do erro
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.errorLayoutView.isHidden = true
        filteredMovies = []
        resultsCollectionView.reloadData()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // Se nao tiver mais nenhum caracter na busca, limpa a collection e tira o layout do erro
        if searchText == "" {
            self.errorLayoutView.isHidden = true
            filteredMovies = []
            resultsCollectionView.reloadData()
        }
    }
}


