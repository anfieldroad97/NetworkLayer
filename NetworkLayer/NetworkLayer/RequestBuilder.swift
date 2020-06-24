//
//  RequestBuilder.swift
//  NetworkLayer
//
//  Created by Mirzhan Gumarov on 6/24/20.
//  Copyright © 2020 Mirzhan Gumarov. All rights reserved.
//

import Foundation

class RequestBuilder {
    private let baseURL: URL
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    func buildRequest(from apiRequest: APIRequest) -> URLRequest {
        let fullURL: URL = buildURL(path: apiRequest.path, query: apiRequest.queryItems)
        
        var urlRequest = URLRequest(url: fullURL)
        urlRequest.httpMethod = apiRequest.method.rawValue
        urlRequest.httpBody = apiRequest.body
        apiRequest.headers?.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.field) }
        
        return urlRequest
    }
    
    private func buildURL(path: String, query: [URLQueryItem]?) -> URL {
        let baseURL: String = self.baseURL.absoluteString
        let fullPath: String = baseURL.concatenating(path: path)
        
        
        guard let url = URL(string: fullPath) else {
            fatalError("Failed to initialize URL")
        }
        
        if let unwrappedQuery = query, var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            urlComponents.queryItems = unwrappedQuery
            
            guard let url = urlComponents.url else { fatalError() }
            return url
        }
        
        return url
    }
}
