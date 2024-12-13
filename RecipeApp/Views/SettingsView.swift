//
//  SettingsView.swift
//  RecipeApp
//
//  Created by Ronan Kelly on 12/12/24.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject private var viewModel: RecipeServiceViewModel
    
    var body: some View {
        List {
            
            Section("Selected Endpoint") {
                Text(viewModel.currentEndpoint.absoluteString)
                    .font(.system(size: 12))
                    .fontDesign(.monospaced)
                    .bold()
            }
            
            Section("Available Endpoints") {
                ForEach(viewModel.availableEndpoints, id: \.self) { endpoint in
                    HStack {
                        icon(endpoint)
                        Text(endpoint.path())
                            .font(.system(size: 12))
                            .fontDesign(.monospaced)
                        Spacer()
                    }
                    .onTapGesture {
                        viewModel.currentEndpoint = endpoint
                    }
                }
            }
        }
        .navigationTitle("Settings")
        .listStyle(.plain)
    }
    
    private func icon(_ url: URL) -> some View {
        Circle()
            .fill(url == viewModel.currentEndpoint ? .green : Color(.tertiaryLabel))
            .frame(width: 10, height: 10)
    }
}

#Preview {
    SettingsView()
}
