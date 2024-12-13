//
//  RecipeService.swift
//  RecipeApp
//
//  Created by Ronan Kelly on 12/12/24.
//

import Foundation
import UIKit
import os

/// Service that can download data from a remote server
class EndpointService<T> where T: EndpointServiceDataSource {
    
    // Cache the images
    private let globalImageCache = NSCache<NSURL, UIImage>()
    
    private let decoder = JSONDecoder()
    
    let datasource: T
    
    var currentEndpoint: URL { datasource.retrieveURL() }

    init(datasource: T) {
        self.datasource = datasource
    }    
    
    func recipies() async throws -> RecipeEndpointResponse {
        
        let url = self.datasource.retrieveURL()
        
        let data = try await datasource.retrieveData(for: url)
        
        return try decoder.decode(RecipeEndpointResponse.self, from: data)
    }
    
    func image(_ url: URL) async -> UIImage? {
        
        // Ensure that the image is in the cache
        if let cached = self.globalImageCache.object(forKey: url.ref) {
            return cached
        }
        
        do {
            
            // Attempt to download the data and convert it
            let data = try await datasource.retrieveData(for: url)
            let image = UIImage(data: data)
            
            // If the download is successful, cache the image
            if let image = image {
                self.globalImageCache.setObject(image, forKey: url.ref)
            }
            
            return image
        }
        catch {
            
            os_log(.error, "Unable to download image - %s", error.localizedDescription)
            return nil
        }
    }
}

extension EndpointService where T == ApplicationEndpointServiceDataSource {
    
    var availableEndpoints: [URL] { T.endpoints }
    
    func setEndpoint(url: URL) {
        self.datasource.set(url: url)
    }
}

fileprivate extension URL {
    
    var ref: NSURL { self as NSURL }
}
