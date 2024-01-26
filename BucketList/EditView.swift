//
//  EditView.swift
//  BucketList
//
//  Created by Игорь Верхов on 25.01.2024.
//

import SwiftUI

struct EditView: View {
    @Environment(\.dismiss) var dismiss

    var onSave: (Location) -> Void
    
    @State private var viewModel: ViewModel

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Place name", text: $viewModel.name)
                    TextField("Place description", text: $viewModel.description)
                }
                Section("Nearby") {
                    switch viewModel.loadingState {
                    case .loaded:
                        ForEach(viewModel.pages, id:\.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ") +
                            Text(page.description)
                                .italic()
                        }
                    case .loading:
                        Text("Loading..")
                    case .failed:
                        Text("Please try again later.")
                    }
                }
            }
            .navigationTitle("Place details")
            .toolbar {
                Button("Save") {
                    let newLocation = viewModel.createNewLocation()
                    
                    onSave(newLocation)
                    dismiss()
                }
            }
            .task {
                await viewModel.fetchNearbyPlaces()
            }
        }
    }
    
    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.onSave = onSave
        _viewModel = State(initialValue: ViewModel(location: location))
    }
    
    
}

#Preview {
    EditView(location: .example) { _ in }
}
