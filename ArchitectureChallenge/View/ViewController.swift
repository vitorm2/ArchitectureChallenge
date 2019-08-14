//
//  ViewController.swift
//  ArchitectureChallenge
//
//  Created by Vitor Demenighi on 14/08/19.
//  Copyright © 2019 Vitor Demenighi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.request()
        
    }

    func request(){
        if let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=79bb37b9869aa0ed97dc7a23c93d0829&language=en-US&page=1"){
            let task = URLSession.shared.dataTask(with: url) { (data, request, err) in
                if err == nil {
                    if let dadosRetorno = data {
                        let request = try! JSONDecoder().decode(Request.self, from: dadosRetorno)
                
                        print(request.results[1])
                    }
                }
            }
            task.resume()
        }
    }

}

