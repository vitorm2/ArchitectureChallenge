//
//  SeeAllController.swift
//  Pods-ArchitectureChallenge
//
//  Created by Vitor Demenighi on 19/08/19.
//

import UIKit

class SeeAllController: UIViewController, PresenterSeeAllDelegate{
    
    @IBOutlet weak var countMoviesLabel: UILabel!
    @IBOutlet var nowPlayingCollectionView: UICollectionView!
    
    private let seeAllPresenter = SeeAllPresenter(movieDBService: MovieDBService())
    
    var nowPlaying_moviesToDisplay = [MovieViewData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nowPlayingCollectionView.delegate = self
        nowPlayingCollectionView.dataSource = self
        
        seeAllPresenter.setViewDelegate(presenterSeeAllDelegate: self)
        
        updateCountMoviesLabel()
    }
    
    func segueMovieDetails(movie: MovieDetail) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "segueDetails", sender: movie)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if let movie = sender as? MovieDetail {
            if let nextViewController = segue.destination as? MovieDetailsController {
                nextViewController.movie = movie
            }
        }
    }
    
    func updateCountMoviesLabel() {
        countMoviesLabel.text = "Showing \(nowPlaying_moviesToDisplay.count) results"
    }
}

extension SeeAllController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nowPlaying_moviesToDisplay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "nowPlayingCell2", for: indexPath) as!
        NowPlayingCollectionViewCell
        
        cell.movieComponent.movieTitle.text = nowPlaying_moviesToDisplay[indexPath.row].title
        cell.movieComponent.movieVoteAverage.text = String(nowPlaying_moviesToDisplay[indexPath.row].vote_average)

        let imageURL = base_url + nowPlaying_moviesToDisplay[indexPath.row].poster_path
        let url = URL(string: imageURL)

        cell.movieComponent.movieImage?.sd_setImage(with: url, placeholderImage: nil)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        seeAllPresenter.showMovieDetails(movieId: nowPlaying_moviesToDisplay[indexPath.row].id)
    }
}
