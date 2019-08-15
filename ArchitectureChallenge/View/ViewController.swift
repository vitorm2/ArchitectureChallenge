//
//  ViewController.swift
//  ArchitectureChallenge
//
//  Created by Vitor Demenighi on 14/08/19.
//  Copyright © 2019 Vitor Demenighi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ListViewDelegate, UICollectionViewDelegate {

    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDescription: UILabel!
    
    @IBOutlet weak var nowPlayingMoviesCollectionView: UICollectionView!
    
    
    var movies: [Movie]?
    
    private let listViewPresenter = Presenter(movieDBService: MovieDBService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nowPlayingMoviesCollectionView.dataSource = self
        nowPlayingMoviesCollectionView.delegate = self
        
        
        listViewPresenter.setViewDelegate(listViewDelegate: self)
        
        // Diz para o presenter pegar os filmes
        listViewPresenter.showNowPlayingMovies()
    }
    
    // O presenter passa para a funcao os filmes buscados
    func displayNowPlaying(movies: [Movie]) {
        DispatchQueue.main.async {
            self.movies = movies
            self.nowPlayingMoviesCollectionView.reloadData()
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


extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "nowPlayingCell", for: indexPath) as! NowPlayingMovieCell
        cell.movieTitle.text = movies?[indexPath.row].title
        
//        cell.layer.cornerRadius = 10.0
//        cell.layer.masksToBounds = false
//        cell.layer.shadowColor = UIColor.gray.cgColor
//        cell.layer.shadowRadius = 10
//        cell.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
//        cell.layer.shadowOpacity = 0.25
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Diz para o presenter pegar os detalhes de um filme de acordo com o id passado
        listViewPresenter.showMovieDetails(movieId: movies?[indexPath.row].id ?? 0)
    }
    
    
    
}

