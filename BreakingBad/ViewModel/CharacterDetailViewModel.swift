//
//  CharacterDetailViewModel.swift
//  BreakingBad
//
//  Created by James Buckley on 08/11/2022.
//

import SwiftUI
import Combine

class CharacterDetailViewModel: ObservableObject, Identifiable {
    @Published var character: Character
    
    init(character: Character) {
        self.character = character
    }

    var getOccupationString: String {
        if character.occupation.count > 0 {
            return character.occupation.joined(separator: ", ")
        } else {
            return ""
        }
    }
    
    func setFavourite() {
        let realmManager = RealmManager()
        character.isFavourite.toggle()
        realmManager.setCharacterFavourite(id: character.char_id, bool: character.isFavourite)
    }
}
