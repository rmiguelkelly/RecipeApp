//
//  Recipe.swift
//  RecipeApp
//
//  Created by Ronan Kelly on 12/12/24.
//

import Foundation

/// Represents a single recipe
struct Recipe: Codable {
    
    /// The cuisine of the recipe.
    let cuisine: String
    
    /// The name of the recipe.
    let name: String
    
    /// The URL of the recipes’s full-size photo.
    let photo_url_large: URL?
    
    /// The URL of the recipes’s small photo. Useful for list view.
    let photo_url_small: URL?
    
    /// The unique identifier for the receipe. Represented as a UUID.
    let uuid: UUID
    
    /// The URL of the recipe's original website.
    let source_url: URL?
    
    /// The URL of the recipe's YouTube video.
    let youtube_url: URL?
}

extension Recipe: Identifiable {
    
    var id: UUID { self.uuid }
}

