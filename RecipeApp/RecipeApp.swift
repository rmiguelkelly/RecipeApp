//
//  RecipeAppApp.swift
//  RecipeApp
//
//  Created by Ronan Kelly on 12/12/24.
//

import SwiftUI

@main
struct RecipeApp: App {
    
    private let endpointService = EndpointService(datasource: ApplicationEndpointServiceDataSource())
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView(service: endpointService)
            }
            .environmentObject(RecipeServiceViewModel(endpointService: self.endpointService))
        }
    }
}
