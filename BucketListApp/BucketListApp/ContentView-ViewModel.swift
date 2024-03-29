//
//  ContentView-ViewModel.swift
//  BucketListApp
//
//  Created by Alpay Calalli on 18.09.22.
//

import Foundation
import LocalAuthentication
import MapKit

extension ContentView {
    
    @MainActor class ViewModel: ObservableObject {
        @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
        @Published private(set) var locations: [Location]
        @Published var selectedLocation: Location?
        @Published var isUnlocked = true
        @Published var showBioAlert = false
        
        let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedPlaces")
        
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
        
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomicWrite, .completeFileProtection])
            } catch {
                print("Unable to save data")
            }
        }
        
        func addLocation() {
            let newLocation = Location(id: UUID(), name: "New location", description: "", latitude: mapRegion.center.latitude, longitude: mapRegion.center.longitude)
            locations.append(newLocation)
            save()
        }
        
        func update(location: Location) {
            guard let selectedLocation = selectedLocation else { return }

            
            if let index = locations.firstIndex(of: selectedLocation){
                locations[index] = location
                save()
            }
        }
        func autenthicate() {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){ let reason = "Please authenticate yourself to unlock your data."
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason){ success , authenticationError in
                    if success {
                        Task { @MainActor in
                            self.isUnlocked = true
                        }
                    }else{
                        print("Autentication fails")
                    }
                }
            } else {
                showBioAlert = true
            }
        }
    }
}
