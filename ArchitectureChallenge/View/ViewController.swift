//
//  ViewController.swift
//  ArchitectureChallenge
//
//  Created by Vitor Demenighi on 14/08/19.
//  Copyright © 2019 Vitor Demenighi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ListViewDelegate {
    
    @IBOutlet var mainTableView: UITableView!
    
    var nowPlaying_moviesToDisplay = [MovieViewData]()
    var popular_moviesToDisplay = [MovieViewData]()
    
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    private let listViewPresenter = Presenter(movieDBService: MovieDBService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainTableView.dataSource = self
        mainTableView.delegate = self
        
        listViewPresenter.setViewDelegate(listViewDelegate: self)
        
        // Diz para o presenter pegar os filmes
        listViewPresenter.getNowPlayingMovies()
        listViewPresenter.getPopularMovies()
        
        setupNavBar()
    }
    
    // Coloca título grande e Search Bar na Navigation Bar
    func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    // O presenter passa para a funcao os filmes buscados
    func setNowPlayingMovies(moviesData: [MovieViewData]){
        nowPlaying_moviesToDisplay = moviesData
        DispatchQueue.main.async {
            self.mainTableView.reloadData()
        }
    }
    
    func setPopularMovies(moviesData: [MovieViewData]){
        popular_moviesToDisplay = moviesData
        DispatchQueue.main.async {
            self.mainTableView.reloadData()
        }
    }
    
    
    // O presenter retorna para a funcao o Objeto filme detalhado
    func segueMovieDetails(movie: MovieDetail) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "movieDetailsSegue", sender: movie)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let movie = sender as? MovieDetail {
            if let nextViewController = segue.destination as? MovieDetailsController {
                nextViewController.movie = movie
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
        case 0 : return 1
        case 1 : return popular_moviesToDisplay.count
        default : fatalError("There should be no more sections")
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0 : return 260
        case 1 : return 160
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
            
            if  let cell = tableView.dequeueReusableCell(withIdentifier: "popularMoviesCell") as? PopularMoviesTableViewCell {
                let movie = popular_moviesToDisplay[indexPath.row]
                cell.movieTitle.text = movie.title
                cell.voteAverage.text = String(movie.vote_average ?? 0.0)
                return cell
            }
            
            return UITableViewCell()
            
        default : fatalError("There should be no more sections")
            
        }

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0 : return HeaderView()
        case 1 : return HeaderView()
        default : fatalError("There should be no more sections")
        }
    }
    
}

extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nowPlaying_moviesToDisplay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "nowPlayingCell", for: indexPath) as! NowPlayingCollectionViewCell
        cell.movieTitleLabel.text = nowPlaying_moviesToDisplay[indexPath.row].title
        cell.moviePosterImageView.image = nil
        
        if let imageFromCache = imageCache.object(forKey: nowPlaying_moviesToDisplay[indexPath.row].poster_path as AnyObject) as? UIImage {
            cell.moviePosterImageView.image = imageFromCache
            return cell
        }
        
        listViewPresenter.getMovieImage(imagePath: nowPlaying_moviesToDisplay[indexPath.row].poster_path) { (data) in
            DispatchQueue.main.async {
                let imageToCache = UIImage(data: data!)
                
                // Adiciona a UIImage na cache ao scrollar a collection para não gastar recurso do usuário
                self.imageCache.setObject(imageToCache!, forKey: self.nowPlaying_moviesToDisplay[indexPath.row].poster_path as AnyObject)
                
                cell.moviePosterImageView.image = imageToCache
            }
        }
        
        return cell
    }
    
    //    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //
    //        // Diz para o presenter pegar os detalhes de um filme de acordo com o id passado
    //        listViewPresenter.showMovieDetails(movieId: movies?[indexPath.row].id ?? 0)
    //    }
    
    
    
}



