//
//  RealmManager.swift
//  BreakingBad
//
//  Created by James Buckley on 08/11/2022.
//

import Foundation
import RealmSwift

class RealmManager: ObservableObject {
    private(set) var localRealm: Realm?
    @Published private(set) var characterData: [CharacterData] = []
    
    init() {
        openRealm()
        getCharacters()
    }
    
    func openRealm() {
        do {
            let config = Realm.Configuration(schemaVersion: 1)
            
            Realm.Configuration.defaultConfiguration = config
            
            localRealm = try Realm()
        } catch {
            print("Error opening Realm: \(error)")
        }
    }
    
    func addCharacter(id: Int, bool: Bool) {
        if let localRealm = localRealm {
            do {
                try localRealm.write {
                    let newChar = CharacterData(value: ["id": id, "isFavourite": bool])
                    localRealm.add(newChar)
                    print("Added new character to realm \(newChar)")
                }
            } catch {
                print("Error")
            }
        }
    }
    
    func getCharacters() {
        if let localRealm = localRealm {
            let allChars = localRealm.objects(CharacterData.self)
            characterData = []
            allChars.forEach { char in
                characterData.append(char)
            }
        }
    }
    
    func setCharacterFavourite(id: Int, bool: Bool) {
        if let localRealm = localRealm {
            do {
                let charToUpdate = localRealm.objects(CharacterData.self).filter { $0.id == id }
                
                if charToUpdate.isEmpty {
                    addCharacter(id: id, bool: bool)
                } else {
                    try localRealm.write {
                        charToUpdate[0].isFavourite = bool
                        print("Updated character \(charToUpdate)")
                    }
                }
                
                getCharacters()
            } catch {
                print("Error saving character")
            }
        }
    }
 
}
