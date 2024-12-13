//
//  RecipeFeedPage.swift
//  RecipeApp
//
//  Created by Ronan Kelly on 12/12/24.
//

import SwiftUI

struct RecipeFeedPage: View {
    
    @EnvironmentObject private var viewModel: RecipeServiceViewModel
    
    private let service: EndpointService<ApplicationEndpointServiceDataSource>
    
    init(service: EndpointService<ApplicationEndpointServiceDataSource>) {
        self.service = service
    }
    
    var body: some View {
        List {
            ForEach(viewModel.allRecipes) { recipe in
                RecipeCell(recipe: recipe)
                    .environmentObject(viewModel)
            }
        }
        .listStyle(PlainListStyle())
    }
}
