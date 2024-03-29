//
//  ContentView.swift
//  BucketListApp
//
//  Created by Alpay Calalli on 14.09.22.
//

import MapKit
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    var body: some View {
        if viewModel.isUnlocked {
            ZStack {
                Map(coordinateRegion: $viewModel.mapRegion, annotationItems: viewModel.locations){ location in
                    MapAnnotation(coordinate: location.coordinate){
                        VStack {
                            Image(systemName: "star.circle")
                                .resizable()
                                .foregroundColor(.red)
                                .frame(width: 44, height: 44)
                                .background(.white)
                                .clipShape(Circle())
                            
                            Text(location.name)
                                .fixedSize()
                            
                        }
                        .onTapGesture {
                            viewModel.selectedLocation = location
                        }
                    }
                }
                .ignoresSafeArea()
                
                Circle()
                    .fill(.blue)
                    .opacity(0.3)
                    .frame(width: 32, height: 32)
                
                VStack{
                    Spacer()
                    
                    HStack{
                        Spacer()
                        Button{
                            viewModel.addLocation()
                        }label: {
                            Image(systemName: "plus")
                                .padding()
                                .background(.black.opacity(0.75))
                                .foregroundColor(.white)
                                .font(.title)
                                .clipShape(Circle())
                                .padding(.trailing)
                        }
                    }
                }
            }
            .sheet(item: $viewModel.selectedLocation){ place in
                EditView(location: place){ newLocation in
                    viewModel.update(location: newLocation)
                }
            }
            .alert("Oops, try again!",isPresented: $viewModel.showBioAlert){
                Button("Cancel", role: .cancel){ }
            }message: {
                Text("Some problem with your biometric authentication")
            }
        } else {
            Button("Unlock places"){
                viewModel.autenthicate()
            }
            .padding()
            .background(.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
