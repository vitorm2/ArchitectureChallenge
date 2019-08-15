//
//  Movie.swift
//  ArchitectureChallenge
//
//  Created by Vitor Demenighi on 14/08/19.
//  Copyright © 2019 Vitor Demenighi. All rights reserved.
//

import Foundation

struct Movies: Codable {
    var results: [Movie]
    var page: Int?
    var total_results: Int?
    var dates: Dates?
    var total_pages: Int?
}

struct Movie: Codable {
    var vote_count: Int?
    var id: Int?
    var video: Bool?
    var vote_average: Double?
    var title: String?
    var popularity: Double?
    var poster_path: String?
    var original_language: String?
    var original_title: String?
    var genre_ids: [Int]?
    var backdrop_path: String?
    var adult: Bool?
    var overview: String?
    var release_date: String?
}

struct Dates: Codable {
    let maximum: String?
    let minimum: String?
}

