//
//  EditView-ViewModifier.swift
//  BucketListApp
//
//  Created by Alpay Calalli on 20.09.22.
//

import Foundation
import SwiftUI

extension EditView{
    @MainActor class ViewModel: ObservableObject {
        
        enum LoadingState{
            case loading, loaded, failed
        }
        
        @Published var name: String
        @Published var description: String
        
        @Published var loadingState = LoadingState.loading
        @Published var pages: [Page] = []
        var location: Location
        
        init(location: Location) {
          name = location.name
          description = location.description
          self.location = location
        }
        
        func fetchData() async {
            let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.latitude)%7C\(location.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
            
            guard let url = URL(string: urlString) else {
                print("Bad url, try again!")
                return
            }
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let items = try JSONDecoder().decode(Result.self, from: data)
                pages = items.query.pages.values.sorted()
                loadingState = .loaded
            } catch {
                loadingState = .failed
            }
        }
        
    }
}
