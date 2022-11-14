//
//  CharacterReviewView.swift
//  BreakingBad
//
//  Created by James Buckley on 10/11/2022.
//

import SwiftUI
import Combine

private enum Field: Int, CaseIterable {
    case name, reviewText
}

struct CharacterReviewView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var viewModel: CharacterReviewViewModel
    @State private var reviewTextEditorHeight: CGFloat = 200
    @FocusState private var focusedField: Field?
    
    init(characterViewModel: CharacterReviewViewModel) {
        self.viewModel = characterViewModel
    }
    
    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading) {
                    Text("Your name")
                        .multilineTextAlignment(.leading)
                    TextField("", text: $viewModel.name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .focused($focusedField, equals: .name)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button("Done") {
                                    focusedField = nil
                                }
                                .foregroundColor(.green)
                            }
                        }
                }
            }
            Section {
                DatePicker(
                    "Date viewed",
                    selection: $viewModel.dateViewed,
                    displayedComponents: [.date]
                )
            }
            Section {
                Picker("Rating", selection: $viewModel.rating) {
                    ForEach(0..<11) { starCount in
                        HStack {
                            Text(String(starCount))
                        }
                    }
                }
            }
            Section {
                VStack(alignment: .leading) {
                    Text("Leave a review")
                        .multilineTextAlignment(.leading)
                    TextEditor(text: $viewModel.reviewText).id(0)
                        .focused($focusedField, equals: .reviewText)
                        .frame(height: max(40, reviewTextEditorHeight))
                        .overlay(
                                 RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color(uiColor: UIColor.lightGray), lineWidth: 0.5)
                                 )
                }
            }
            Section {
                Button(action: {
                    
                }) {
                    Spacer()
                    Text("Submit").bold()
                    Spacer()
                }
                .frame(maxWidth: .infinity, minHeight: 40)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(5)
                .onTapGesture {
                    viewModel.submitReview()
                    dismiss()
                }
            }
            .listRowBackground(Color.clear)
        }
    }
}

