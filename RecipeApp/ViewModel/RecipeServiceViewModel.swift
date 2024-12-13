//
//  RecipeServiceViewModel.swift
//  RecipeApp
//
//  Created by Ronan Kelly on 12/12/24.
//

import Foundation
import UIKit

class RecipeServiceViewModel: ObservableObject {
    
    static private var likedRecipesUserDefaultsKey = "com.recipes.likes"
    
    enum RecipeState: Equatable {
        case loading
        case error
        case success
    }
    
    private let endpointService: EndpointService<ApplicationEndpointServiceDataSource>
    
    private let storage: UserDefaults = UserDefaults.standard
    
    @Published var currentState: RecipeState = .loading
    
    @Published var allRecipes: [Recipe] = []
    
    @Published var currentEndpoint: URL {
        didSet {
            self.endpointService.setEndpoint(url: currentEndpoint)
        }
    }
    
    @Published var likedRecipes: Set<UUID> = [] {
        didSet {
            let uuids = likedRecipes.map { $0.uuidString }
            self.storage.setValue(uuids, forKey: Self.likedRecipesUserDefaultsKey)
        }
    }
    
    var availableEndpoints: [URL] { endpointService.availableEndpoints }
    
    init(endpointService: EndpointService<ApplicationEndpointServiceDataSource>) {
        self.endpointService = endpointService
        self.currentEndpoint = endpointService.currentEndpoint
        
        if let uuids = self.storage.stringArray(forKey: Self.likedRecipesUserDefaultsKey) {
            likedRecipes = uuids
                .compactMap { UUID(uuidString: $0) }
                .set()
        }
    }
    
    /// Downloads the recipes from the server
    @MainActor func download() async {
        
        do {
            // Call the service
            let result = try await endpointService.recipies()
            
            // Save the results
            self.currentState = .success
            self.allRecipes = result.recipes
        }
        catch {
            self.currentState = .error
        }
    }
    
    @MainActor func thumbnail(_ recipe: Recipe) async -> UIImage? {
        
        guard let url = recipe.photo_url_small else {
            return nil
        }
        
        return await endpointService.image(url)
    }
    
    @MainActor func background(_ recipe: Recipe) async -> UIImage? {
        
        guard let url = recipe.photo_url_large else {
            return nil
        }
        
        return await endpointService.image(url)
    }
}
