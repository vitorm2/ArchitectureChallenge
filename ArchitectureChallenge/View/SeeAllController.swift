//
//  SeeAllController.swift
//  Pods-ArchitectureChallenge
//
//  Created by Vitor Demenighi on 19/08/19.
//

import UIKit

class SeeAllController: UIViewController{
    
   var nowPlaying_moviesToDisplay = [MovieViewData]()
    @IBOutlet var nowPlayingCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nowPlayingCollectionView.delegate = self
        nowPlayingCollectionView.dataSource = self
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
}
