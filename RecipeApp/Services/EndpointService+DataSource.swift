//
//  EndpointService+DataSource.swift
//  RecipeApp
//
//  Created by Ronan Kelly on 12/12/24.
//

import Foundation
import os

protocol EndpointServiceDataSource: AnyObject {
    
    func retrieveData(for url: URL) async throws -> Data
    
    func retrieveURL() -> URL
}

class ApplicationEndpointServiceDataSource: EndpointServiceDataSource {
    
    static let endpoints: [URL] = [
        URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!,
        URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json")!,
        URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json")!,
    ]
    
    private var current: URL
    
    let session: URLSession
    
    init(_ session: URLSession = .shared) {
        self.current = Self.endpoints[0]
        self.session = session
    }
    
    func set(url: URL) {
        os_log("Set endpoint to \(url)")
        self.current = url
    }
    
    func retrieveData(for url: URL) async throws -> Data {
        
        let start = CFAbsoluteTimeGetCurrent()
        
        let (data, result) = try await session.data(from: url)
        
        let httpres = result as! HTTPURLResponse
        let statusCode = httpres.statusCode
        
        // If the status code is invalid range throw an error
        guard 200..<300 ~= statusCode else {
            os_log(.error, "Invalid status code for %s - %d", url.absoluteString, statusCode)
            let code = URLError.Code(rawValue: statusCode)
            throw URLError(code)
        }
        
        // Uncomment to simulate network latency
        // try await Task.sleep(for: .seconds(2))
        
        let end = CFAbsoluteTimeGetCurrent()
        
        let msElapsed = Int((end - start) * 1000)
        
        os_log("Retrieved %d byte[s], took %dms", data.count, msElapsed)
        
        return data
    }
    
    func retrieveURL() -> URL {
        return current
    }
}
 
