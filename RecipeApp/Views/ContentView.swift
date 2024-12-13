//
//  ContentView.swift
//  RecipeApp
//
//  Created by Ronan Kelly on 12/12/24.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject private var viewModel: RecipeServiceViewModel
    
    @State private var displaySettingsView: Bool = false
    
    let service: EndpointService<ApplicationEndpointServiceDataSource>
    
    init(service: EndpointService<ApplicationEndpointServiceDataSource>) {
        self.service = service
    }
    
    var body: some View {
        VStack {
            switch viewModel.currentState {
            case .loading:
                ProgressView()
            case .error:
                VStack {
                    Text("Unable to download recipes!")
                        .foregroundStyle(.red)
                        .bold()
                }
            case .success:
                if viewModel.allRecipes.isEmpty {
                    Text("No Recipies Available")
                        .bold()
                }
                else {
                    RecipeFeedPage(service: service)
                }
            }
        }
        .animation(.default, value: viewModel.currentState)
        .navigationTitle("Recipies")
        .toolbar(content: settingsButton)
        .sheet(isPresented: self.$displaySettingsView) {
            NavigationStack {
                SettingsView()
            }
        }
        .onAppear {
            beginDownload()
        }
        .onReceive(viewModel.$currentEndpoint) { _ in
            beginDownload()
        }
        .refreshable {
            beginDownload()
        }
    }
    
    private func settingsButton() -> some View {
        Button(action: showSettingsView) {
            Image(systemName: "gear")
                .foregroundStyle(Color.customColor3)
        }
    }
    
    private func showSettingsView() {
        self.displaySettingsView = true
    }
    
    private func beginDownload() {
        Task {
            await viewModel.download()
        }
    }
}

#Preview {
    ContentView(service: EndpointService(datasource: ApplicationEndpointServiceDataSource()))
}
