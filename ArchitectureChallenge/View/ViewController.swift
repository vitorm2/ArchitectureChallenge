//
//  ViewController.swift
//  ArchitectureChallenge
//
//  Created by Vitor Demenighi on 14/08/19.
//  Copyright © 2019 Vitor Demenighi. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController: UIViewController, ListViewDelegate, HeaderDelegate {
   
    @IBOutlet var mainTableView: UITableView!
    
    var allNowPlaying_moviesToDisplay = [MovieViewData]()
    var nowPlaying_moviesToDisplay = [MovieViewData]()
    var firstFiveNowPlaying_moviesToDisplay = [MovieViewData]()
    
    var errorNowPlaying: Bool = false
    
    var popular_moviesToDisplay = [MovieViewData]()
    
    private let listViewPresenter = Presenter(movieDBService: MovieDBService())
    
    var resultsNavigationController : UINavigationController!
    var resultsViewController : ResultsViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainTableView.dataSource = self
        mainTableView.delegate = self
        
        listViewPresenter.setViewDelegate(listViewDelegate: self)
        
        // Diz para o presenter pegar os filmes
        listViewPresenter.getNowPlayingMovies()
        listViewPresenter.getFiveNowPlayingMovies()
        listViewPresenter.getPopularMovies()
        
        let headerXib = UINib(nibName: "HeaderView", bundle: nil)
        mainTableView.register(headerXib, forHeaderFooterViewReuseIdentifier: "HeaderView")
        
        mainTableView.separatorStyle = .none
        
        resultsNavigationController = UIStoryboard(name: "Results", bundle: nil).instantiateViewController(withIdentifier: "navigationController") as? UINavigationController
        resultsViewController = resultsNavigationController.topViewController as? ResultsViewController
        
        setupNavBar()

    }
    
    // Coloca título grande e Search Bar na Navigation Bar
    func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let searchController = UISearchController(searchResultsController: resultsViewController)
        searchController.searchResultsUpdater = resultsViewController
        searchController.obscuresBackgroundDuringPresentation = true
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        self.definesPresentationContext = true
    }
    
    // O presenter passa para a funcao os filmes buscados
    func setNowPlayingMovies(moviesData: [MovieViewData]){
        allNowPlaying_moviesToDisplay = moviesData
        resultsViewController.filteredMovies = moviesData
    }
    
    func setPopularMovies(moviesData: [MovieViewData]){
        popular_moviesToDisplay = moviesData
        DispatchQueue.main.async {
            self.mainTableView.reloadData()
        }
    }
    
    func setFiveNowPlayingMovies(moviesData: [MovieViewData]) {
        nowPlaying_moviesToDisplay = moviesData
        DispatchQueue.main.async {
            self.mainTableView.reloadData()
        }
    }
    
    func showError(error: ServiceError) {
        print(error.status_message)
        errorNowPlaying = true
    }
    
    func seeAllButtonTouched() {
        self.performSegue(withIdentifier: "segueSeeAll", sender: allNowPlaying_moviesToDisplay)
    }
    
    // O presenter retorna para a funcao o Objeto filme detalhado
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
        }
        if let movies = sender as? [MovieViewData] {
            if let nextViewController = segue.destination as?
                SeeAllController {
                nextViewController.nowPlaying_moviesToDisplay = movies
            }
        }
    }

}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0 : if errorNowPlaying { return 0 } else { return 1 }
        case 1 : return popular_moviesToDisplay.count
        default : fatalError("There should be no more sections")
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0 : if errorNowPlaying { return 0 } else { return 340 }
        case 1 : return 140
        default : fatalError("There should be no more sections")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.section {
            
        case 0 :

            if let cell = tableView.dequeueReusableCell(withIdentifier: "nowPlayingTableViewCell", for: indexPath) as? NowPlayingTableViewCell {
                cell.nowPlayingCollectionView.dataSource = self
                cell.nowPlayingCollectionView.delegate = self
                cell.nowPlayingCollectionView.reloadData()
                return cell
            }
        
            
            return UITableViewCell()
            
        case 1 :
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "popularMoviesCell") as! PopularMoviesTableViewCell
            
            let movie = popular_moviesToDisplay[indexPath.row]
            
            let imageURL = base_url + popular_moviesToDisplay[indexPath.row].poster_path
            let url = URL(string: imageURL)
            
            cell.moviePoster.sd_setImage(with: url, placeholderImage: nil)
            cell.movieTitle.text = movie.title
            
            cell.movieDescription.text = movie.overview
            cell.movieDescription.lineBreakMode = .byTruncatingTail
            cell.movieDescription.numberOfLines = 0
            
            cell.voteAverage.text = String(movie.vote_average)
            
            return cell
            
        default : fatalError("There should be no more sections")
            
        }

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderView") as? HeaderView
        else { return nil }

                switch section {
                case 0 :
                    if errorNowPlaying {
                        headerView.isHidden = true
                    } else {
                        headerView.headerTitle.text = "Now Playing"
                        headerView.actionButton.setTitle("See all", for: .normal)
                        headerView.actionButton.isHidden = false
                        headerView.delegate = self
                    }
                case 1 :
                    headerView.headerTitle.text = "Popular Movies"
                    headerView.actionButton.isHidden = true
                default : fatalError("There should be no more sections")
                }
        
        return headerView

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if errorNowPlaying && section == 0 {
            return 0
        } else {
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderView") as? HeaderView
                else { return 0.0 }
            return headerView.bounds.height
        }
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        listViewPresenter.showMovieDetails(movieId: popular_moviesToDisplay[indexPath.row].id)
    }
    
}

extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nowPlaying_moviesToDisplay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "nowPlayingCell", for: indexPath) as! NowPlayingCollectionViewCell
        
        cell.movieComponent.movieTitle.text = nowPlaying_moviesToDisplay[indexPath.row].title
        cell.movieComponent.movieVoteAverage.text = String(nowPlaying_moviesToDisplay[indexPath.row].vote_average)
        
        let imageURL = base_url + nowPlaying_moviesToDisplay[indexPath.row].poster_path
        let url = URL(string: imageURL)

        cell.movieComponent.movieImage?.sd_setImage(with: url, placeholderImage: nil)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Diz para o presenter pegar os detalhes de um filme de acordo com o id passado
        listViewPresenter.showMovieDetails(movieId: nowPlaying_moviesToDisplay[indexPath.row].id)
    }
}
