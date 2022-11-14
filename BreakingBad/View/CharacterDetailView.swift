//
//  CharacterDetailView.swift
//  BreakingBad
//
//  Created by James Buckley on 05/11/2022.
//

import SwiftUI

struct CharacterDetailView: View {
    
    @EnvironmentObject private var characterManager: CharacterManager
    @ObservedObject private var viewModel: CharacterDetailViewModel
    @State private var showingReviewSheet = false
  
    init(characterViewModel: CharacterDetailViewModel) {
        self.viewModel = characterViewModel
    }
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string:viewModel.character.img)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                case .failure:
                    // Show default system image if download fails
                    Image(systemName: "photo")
                @unknown default:
                    EmptyView()
                }
            }
            .cornerRadius(5)
            HStack {
                Button(action: {
                    characterManager.setFavourite(forCharacter: viewModel.character)
                }) {
                    HStack {
                        Spacer()
                        if viewModel.character.isFavourite {
                            Text("Liked")
                                .foregroundColor(.green)
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(.green)
                        } else {
                            Text("Like")
                        }
                        Spacer()
                      
                    }
                    .frame(alignment: .center)
                    
                }
                .frame(maxWidth: .infinity, minHeight: 40)
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(5)
                Button(action: {
                    showingReviewSheet.toggle()
                }) {
                    Spacer()
                    Text("Review")
                    Spacer()
                }
                .frame(maxWidth: .infinity, minHeight: 40)
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(5)
                .sheet(isPresented: $showingReviewSheet) {
                    NavigationStack {
                        CharacterReviewView(characterViewModel: CharacterReviewViewModel(character: viewModel.character, characterManager: characterManager))
                            .toolbar {
                                ToolbarItem(placement: .primaryAction) {
                                    Button(action: {
                                        self.showingReviewSheet.toggle()
                                    }, label: {
                                        Text("Cancel")
                                    })
                                    .foregroundColor(.green)
                                }
                            }
                    }
                }
            }
            .padding()
            .cornerRadius(5)
            List {
                Section(header: Text("OCCUPATION")) {
                    Text(viewModel.getOccupationString)
                }
                Section(header: Text("NICKNAME")) {
                    Text(viewModel.character.nickname)
                }
                Section(header: Text("BIRTHDAY")) {
                    Text(viewModel.character.birthday)
                }
                Section(header: Text("STATUS")) {
                    Text(viewModel.character.status)
                }
                Section(header: Text("PORTRAYED BY")) {
                    Text(viewModel.character.portrayed)
                }
            }
        }
        .navigationTitle(viewModel.character.name)
        .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(red: 0.039, green: 0.333, blue: 0.184)/*@END_MENU_TOKEN@*/)
    }
}

