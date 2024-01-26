//
//  ContentView.swift
//  BucketList
//
//  Created by Игорь Верхов on 26.09.2023.
//

import MapKit
import SwiftUI

struct ContentView: View {
    
    @State private var viewModel = ViewModel()
    
    @AppStorage("mapStyle") private var standartMode = true
    
    let startPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 56, longitude: -3),
            span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
    )
    
    var body: some View {
        if viewModel.isUnlocked {
            ZStack {
                MapReader { proxy in
                    Map(initialPosition: startPosition) {
                        ForEach(viewModel.locations) { location in
                            Annotation(location.name, coordinate: location.coordinate) {
                                Image(systemName: "star.circle")
                                    .resizable()
                                    .foregroundStyle(.red)
                                    .frame(width: 44, height: 44)
                                    .background(.white)
                                    .clipShape(.circle)
                                    .onLongPressGesture {
                                        viewModel.selectedPlace = location
                                    }
                            }
                        }
                    }
                    .mapStyle(standartMode ? .standard : .hybrid)
                    .sheet(item: $viewModel.selectedPlace) { place in
                        EditView(location: place) { newLocation in
                            viewModel.update(location: newLocation)
                        }
                    }
                    .onTapGesture { position in
                        if let coordinate = proxy.convert(position, from: .local) {
                            viewModel.addLocation(at: coordinate)
                        }
                    }
                }
                
                VStack() {
                        Picker("Map mode", selection: $standartMode) {
                            Label("Standart", systemImage: "map")
                                .tag (true)
                            Label("Hybrid", systemImage: "map.fill")
                                .tag (false)
                        }
                        .pickerStyle(.segmented)
                        .padding()
                    .frame(maxWidth: 250)
                    .containerRelativeFrame(.horizontal) { width, axis in
                        width * 0.6
                    }
                    Spacer()
                }
            }
        } else {
            Button("Unlock Places", action: viewModel.authenticate)
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(.capsule)
                .alert("Authentication error", isPresented: $viewModel.showingErrorAlert) {
                } message: {
                    Text(viewModel.alertMessage)
                }
        }
    }
}

#Preview {
    ContentView()
}
