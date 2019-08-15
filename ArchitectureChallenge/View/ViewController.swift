//
//  ViewController.swift
//  ArchitectureChallenge
//
//  Created by Vitor Demenighi on 14/08/19.
//  Copyright © 2019 Vitor Demenighi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var movie : String = "Title1"
    var movieDesc : String = "none"

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func setMovieDescription(desc: String) {
        self.movieDesc = desc
    }
}

