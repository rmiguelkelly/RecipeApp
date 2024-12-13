//
//  RecipeAppTests.swift
//  RecipeAppTests
//
//  Created by Ronan Kelly on 12/12/24.
//

import XCTest
@testable import RecipeApp

final class RecipeAppTests: XCTestCase {
    
    var endpointService: EndpointService<MockEndpointServiceDataSource>!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        endpointService = EndpointService(datasource: MockEndpointServiceDataSource())
    }
    
    
    func testDecoding() async throws {
        
        let result = try await endpointService!.recipies()
        
        let recipies = result.recipes
        
        XCTAssertEqual(recipies.count, 2)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        endpointService = nil
    }

}

class MockEndpointServiceDataSource: EndpointServiceDataSource {
    
    func retrieveData(for url: URL) async throws -> Data {
        let jsonRaw = """
        {
          "recipes": [
            {
              "cuisine": "Malaysian",
              "name": "Apam Balik",
              "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
              "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
              "source_url": "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
              "uuid": "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
              "youtube_url": "https://www.youtube.com/watch?v=6R8ffRRJcrg"
            },
            {
              "cuisine": "British",
              "name": "Apple & Blackberry Crumble",
              "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg",
              "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg",
              "source_url": "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble",
              "uuid": "599344f4-3c5c-4cca-b914-2210e3b3312f",
              "youtube_url": "https://www.youtube.com/watch?v=4vhcOwVBDO4"
            },
          ]
        }
        """
        
        return jsonRaw.data(using: .utf8)!
    }
    
    func retrieveURL() -> URL {
        return URL(string: "https://www.exampl.com/")!
    }
    
}
