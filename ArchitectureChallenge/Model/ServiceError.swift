//
//  ServiceError.swift
//  ArchitectureChallenge
//
//  Created by Vitor Demenighi on 20/08/19.
//  Copyright © 2019 Vitor Demenighi. All rights reserved.
//

import Foundation

struct ServiceError: Codable {
    var status_message: String?
    var status_code: Int?
}
