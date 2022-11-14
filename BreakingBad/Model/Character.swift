//
//  Character.swift
//  BreakingBad
//
//  Created by James Buckley on 05/11/2022.
//
import Foundation


struct Character: Codable, Identifiable {
    let id = UUID()
    let char_id: Int
    let name: String
    let birthday: String
    let occupation: [String]
    let img: String
    let status: String
    let nickname: String
    let portrayed: String
    
    var isFavourite: Bool = false
    
    enum CodingKeys: CodingKey {
        case char_id
        case name
        case birthday
        case occupation
        case img
        case status
        case nickname
        case portrayed
    }
}
