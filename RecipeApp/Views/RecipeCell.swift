//
//  RecipeCell.swift
//  RecipeApp
//
//  Created by Ronan Kelly on 12/12/24.
//

import SwiftUI

struct RecipeCell: View {
    
    @EnvironmentObject private var viewModel: RecipeServiceViewModel
    
    @State private var thumbnail: UIImage? = nil
    
    private let recipe: Recipe
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
    
    var body: some View {
        NavigationLink(destination: createRecipeView) {
            HStack {
                if let image = thumbnail {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 44, height: 44)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
                VStack(alignment: .leading) {
                    Text(recipe.name)
                        .bold()
                        .font(.system(size: 12))
                        .padding(.top)
                    cuisineCell
                    Spacer()
                }
                
                Spacer()
                
                if viewModel.likedRecipes.contains(recipe.uuid) {
                    Image(systemName: "heart.fill")
                        .resizable()
                        .foregroundStyle(.red)
                        .frame(width: 14, height: 14)
                }
            }
            .task {
                thumbnail = await viewModel.thumbnail(recipe)
            }
        }
    }
    
    private var cuisineCell: some View {
        Text(recipe.cuisine)
            .font(.system(size: 8))
            .fontWeight(.semibold)
            .padding(.horizontal, 4)
            .padding(.vertical, 1)
            .background(Color.customColor1)
            .clipShape(Capsule())
    }
    
    private func createRecipeView() -> some View {
        RecipeView(recipe: recipe)
    }
}
