//
//  EditView.swift
//  BucketListApp
//
//  Created by Alpay Calalli on 15.09.22.
//

import SwiftUI

struct EditView: View {
    @StateObject private var vm: ViewModel
    
    @Environment(\.dismiss) var dismiss
    var onSave: (Location) -> Void
    
    var body: some View {
        NavigationView{
            Form {
                Section {
                    TextField("Place name", text: $vm.name)
                    TextField("Description", text: $vm.description)
                }
                
                Section("Nearby…"){
                    switch vm.loadingState {
                    case .loading:
                        Text("Loading")
                    case .loaded:
                        ForEach(vm.pages, id: \.pageid){ page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ")
                            + Text(page.description)
                                .italic()
                        }
                    case .failed:
                        Text("Please try again later:(")
                    }
                }
            }
            .navigationTitle("Place details")
            .toolbar{
                Button("Save"){
                    var newLocation = vm.location
                    newLocation.id = UUID()
                    newLocation.name = vm.name
                    newLocation.description = vm.description
                    
                    onSave(newLocation)
                    dismiss()
                }
            }
            .task {
                await vm.fetchData()
            }
        }
        
    }
    
    init(location: Location, onSave: @escaping (Location) -> Void) {
            _vm = StateObject(wrappedValue: ViewModel(location: location))

            self.onSave = onSave
        }
}
