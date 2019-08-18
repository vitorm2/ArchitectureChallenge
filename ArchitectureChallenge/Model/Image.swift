//
//  Image.swift
//  ArchitectureChallenge
//
//  Created by Vitor Demenighi on 15/08/19.
//  Copyright © 2019 Vitor Demenighi. All rights reserved.
//
import Foundation

struct Image: Codable {
    var id: Int?
    var backdrops: [Backdrop]?
    var posters: [Poster]?
    
}

struct Poster: Codable {
    var aspect_ratio: Double?
    var file_path: String?
    var height: Int?
    var iso_639_1: String?
    var vote_average: Double?
    var vote_count: Int?
    var width: Int?
}

struct Backdrop: Codable {
    var aspect_ratio: Double?
    var file_path: String?
    var height: Int?
    var iso_639_1: String?
    var vote_average: Double?
    var vote_count: Int?
    var width: Int?
}
