//
//  CharacterReviewViewModel.swift
//  BreakingBad
//
//  Created by James Buckley on 10/11/2022.
//

import SwiftUI
import Combine

class CharacterReviewViewModel: ObservableObject {
    private var characterManager: CharacterManager
    private var character: Character
    private var reviewCancellable : AnyCancellable?
    
    @Published var rating: Int = 0
    var name: String = ""
    var dateViewed: Date = Date()
    var reviewText: String = ""
    
    init(character: Character, characterManager: CharacterManager) {
        self.character = character
        self.characterManager = characterManager
    }
    
    func submitReview() {
        let review = Review(name: name, dateViewed: dateViewed, reviewText: reviewText, rating: rating)
        reviewCancellable = characterManager.postReview(review: review).sink { result in
            switch result {
            case .failure(let error):
                print(error)
            case .finished:
                print("Review submission finished")
            }
        } receiveValue: { review in
            print(review)
        }

    }
}
