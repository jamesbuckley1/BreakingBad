//
//  CharacterManager.swift
//  BreakingBad
//
//  Created by James Buckley on 09/11/2022.
//

import Foundation
import Combine

class CharacterManager: ObservableObject {
    @Published var characters: [Character] = []
    @Published var isLoading: Bool = false

    private var disposables = Set<AnyCancellable>()
    private var realmManager = RealmManager()

    init() {
        getCharacterData()
    }

    func getCharacterData() {
        if let url = makeUrlComponents(forComponentPath: .characters).url {
            isLoading = true
            URLSession
                .shared
                .dataTaskPublisher(for: url)
                .receive(on: DispatchQueue.main)
                .tryMap({ result in
                    guard let response = result.response as? HTTPURLResponse,
                          response.statusCode >= 200 && response.statusCode <= 300 else {
                        throw CharacterError.invalidStatusCode(description: "Invalid status code")
                    }
                    
                    let decoder = JSONDecoder()
                    guard let characters = try? decoder.decode([Character].self, from: result.data) else {
                        print("Error decoding")
                        throw CharacterError.failedToDecode(description: "Failed to decode JSON")
                    }
                    
                    return characters
                })
                .sink { [weak self] result in
                    defer {
                        self?.isLoading = false
                        self?.getFavouriteCharacters()
                    }
                    
                    switch result {
                    case .failure(let error):
                        print("Error: \(error)")
                    default: break
                    }
                } receiveValue: { [weak self] characters in
                    self?.characters = characters
                }
                .store(in: &disposables)
        }
    }
    
    func postReview<Review>(review: Review) -> AnyPublisher<Review, CharacterError> where Review: Codable {
      return Just(review)
        .encode(encoder: JSONEncoder())
        .mapError { error -> CharacterError in
          if let encodingError = error as? EncodingError {
              return .failedToEncode(description: encodingError.localizedDescription)
          } else {
            return .unknown
          }
      }
      .map { data -> URLRequest in
          var urlRequest = URLRequest(url: self.makeUrlComponents(forComponentPath: .review).url!)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = data
        return urlRequest
      }.flatMap {
        URLSession.shared.dataTaskPublisher(for: $0)
              .mapError(CharacterError.failedRequest)
          .map(\.data)
          .decode(type: Review.self, decoder: JSONDecoder())
          .mapError { error -> CharacterError in
            if let decodingError = error as? DecodingError {
                return .failedToDecode(description: decodingError.localizedDescription)
            } else {
              return .unknown
            }
        }
      }
      .eraseToAnyPublisher()
    }

    func getFavouriteCharacters() {
        realmManager.getCharacters()
        realmManager.characterData.forEach { realmChar in
            for i in characters.indices {
                if characters[i].char_id == realmChar.id {
                    characters[i].isFavourite = realmChar.isFavourite
                }
            }
        }
    }
    
    func setFavourite(forCharacter character: Character) {
        if let index = characters.firstIndex(where: { $0.id == character.id }) {
            characters[index].isFavourite.toggle()
            realmManager.setCharacterFavourite(id: characters[index].char_id, bool: characters[index].isFavourite)
        }
    }
}
// MARK: - BreakingBad API
private extension CharacterManager {
    enum ComponentsPath {
        case characters
        case review
    }
    struct BreakingBadAPI {
        static let scheme = "https"
        static let host = "breakingbadapi.com"
        static let path = "/api"
    }
    
    func makeUrlComponents(forComponentPath path: ComponentsPath) -> URLComponents {
        var components = URLComponents()
        components.scheme = BreakingBadAPI.scheme
        components.host = BreakingBadAPI.host
        components.path = BreakingBadAPI.path + "/\(String(describing: path))"
        
        return components
    }
}
