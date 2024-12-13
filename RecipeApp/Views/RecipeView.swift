//
//  RecipeView.swift
//  RecipeApp
//
//  Created by Ronan Kelly on 12/12/24.
//

import SwiftUI

struct RecipeView: View {
    
    @State private var background: UIImage? = nil
    
    @EnvironmentObject private var viewModel: RecipeServiceViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    private let recipe: Recipe
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
    
    var body: some View {
        VStack {
            
            HStack {
                VStack(alignment: .leading) {
                    Text(recipe.name)
                        .bold()
                        .dynamicTypeSize(.xxLarge)
                        .lineLimit(nil)
                        .multilineTextAlignment(.leading)
                    Text(recipe.cuisine)
                        .font(.system(size: 18))
                        .foregroundStyle(Color(uiColor: .secondaryLabel))
                }
                
                Spacer()
            }
            .padding()
            
            if let image = background {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
                    .overlay {
                        gradient
                        likeButtonOverlay
                            .padding(8)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding()
            }
            
            HStack {
                if let source = recipe.source_url {
                    ShareLink(item: recipe.source_url!) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.label))
                            .frame(width: 44, height: 44)
                            .overlay {
                                Image(systemName: "square.and.arrow.up")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(Color(.systemBackground))
                            }
                    }
                }
                Button(action: openWebsite) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.blue)
                        .frame(height: 44)
                        .overlay {
                            Image(systemName: "safari.fill")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(.white)
                        }
                }
                Button(action: openYoutube) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.hex(0xFF0000))
                        .frame(height: 44)
                        .overlay {
                            Image(systemName: "video.fill")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(.white)
                        }
                }
                
                Spacer()
            }
            .padding()
            
            Spacer()
        }
        .background(Color(.systemBackground))
        .task {
            background = await viewModel.background(recipe)
        }
    }
    
    private func toggleLike() {
        if viewModel.likedRecipes.contains(recipe.uuid) {
            viewModel.likedRecipes.remove(recipe.uuid)
        }
        else {
            viewModel.likedRecipes.insert(recipe.uuid)
        }
    }
    
    private var gradient: some View {
        LinearGradient(
            colors: [
                .black.opacity(0.8),
                .black.opacity(0.0),
            ],
            startPoint: .bottom,
            endPoint: .top
        )
    }
    
    private var likeButtonOverlay: some View {
        HStack(alignment: .bottom) {
            Spacer()
            VStack {
                Spacer()
                Button(action: toggleLike) {
                    Image(systemName: viewModel.likedRecipes.contains(recipe.uuid) ? "heart.fill" : "heart")
                        .resizable()
                        .frame(width: 18, height: 18)
                        .foregroundStyle(.red)
                }
            }
        }
    }
    
    private func openYoutube() {
        
        guard let url = recipe.youtube_url else {
            return
        }
        
        UIApplication.shared.open(url)
    }
    
    private func openWebsite() {
        
        guard let url = recipe.source_url else {
            return
        }
        
        UIApplication.shared.open(url)
    }
    
    private func share() {
        
    }
    
}
