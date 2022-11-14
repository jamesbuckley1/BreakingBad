//
//  ContentView.swift
//  BreakingBad
//
//  Created by James Buckley on 04/11/2022.
//

import SwiftUI

struct CharacterListView: View {
    @StateObject private var characterManager = CharacterManager()
    @StateObject private var realmManager = RealmManager()

    var body: some View {
        NavigationStack {
            if characterManager.isLoading {
                ProgressView()
            } else {
                List(characterManager.characters) { character in
                    NavigationLink {
                        CharacterDetailView(characterViewModel: CharacterDetailViewModel(character: character))
                    } label: {
                        if character.isFavourite {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                        } else {
                            Image(systemName: "star")
                        }
                        Text(character.name)
                    }
                }
                .navigationTitle("Characters")
            }
        }
        .environmentObject(characterManager)
        .environmentObject(realmManager)
        .tint(.white)
    }
}
