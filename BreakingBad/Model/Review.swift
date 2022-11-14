//
//  Review.swift
//  BreakingBad
//
//  Created by James Buckley on 11/11/2022.
//

import Foundation

struct Review: Codable {
    let name: String
    let dateViewed: Date
    let reviewText: String
    let rating: Int
}
