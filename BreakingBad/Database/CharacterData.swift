//
//  CharacterData.swift
//  BreakingBad
//
//  Created by James Buckley on 08/11/2022.
//

import Foundation
import RealmSwift

class CharacterData: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var isFavourite = false
}
