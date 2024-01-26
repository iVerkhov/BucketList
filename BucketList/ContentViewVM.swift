//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by Игорь Верхов on 26.01.2024.
//

import CoreLocation
import Foundation
import LocalAuthentication

extension ContentView {
    @Observable
    class ViewModel {
        private(set) var locations: [Location]
        var selectedPlace: Location?
        
        let savePath = URL.documentsDirectory.appending(path: "SavedPlaces")
        
        var isUnlocked = true
        
        var showingErrorAlert = false
        var alertMessage = ""
        
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
        
        func addLocation(at point: CLLocationCoordinate2D) {
            let newLocation = Location(id: UUID(), name: "New location", description: "", latitude: point.latitude, longitude: point.longitude)
            locations.append(newLocation)
            save()
        }
        
        func update(location: Location) {
            guard let selectedPlace else { return }
            
            if let index = locations.firstIndex(of: selectedPlace) {
                locations[index] = location
            }
            save()
        }
        
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
                print("Unable to save data")
            }
        }
        
        func authenticate() {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please authenticate yourself to unlock your places."
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { succsess, authenticationError in
                    if succsess {
                        self.isUnlocked = true
                    } else {
                        self.alertMessage = "There was a problem authenticating you; please try again."
                        self.showingErrorAlert = true
                    }
                }
            } else {
                self.alertMessage = "Sorry, your device does not support biometric authentication."
                self.showingErrorAlert = true
            }
        }
    }
}
