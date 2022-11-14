//
//  CharacterError.swift
//  BreakingBad
//
//  Created by James Buckley on 05/11/2022.
//

import Foundation

enum CharacterError: Error {
    case invalidStatusCode(description: String)
    case failedToDecode(description: String)
    case failedToEncode(description: String)
    case failedRequest(URLError)
    case unknown
}
