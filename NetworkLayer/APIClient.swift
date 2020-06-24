//
//  APIClient.swift
//  NetworkLayer
//
//  Created by Mirzhan Gumarov on 6/23/20.
//  Copyright © 2020 Mirzhan Gumarov. All rights reserved.
//

import Foundation

class APIClient {
    typealias Handler = (APIResult<Data?>) -> Void
    
    private let session = URLSession.shared
    private let baseURL: URL
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    func perform(_ request: APIRequest, _ completion: @escaping Handler) {
        var urlComponents = URLComponents()
        urlComponents.scheme = baseURL.scheme
        urlComponents.host = baseURL.host
        urlComponents.path = baseURL.path
        urlComponents.queryItems = request.queryItems
        
        guard let url = urlComponents.url?.appendingPathComponent(request.path) else {
            completion(.failure(.invalidURL)); return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body
        
        request.headers?.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.field) }
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(.requestFailed));
                }
                
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(APIResponse<Data?>(statusCode: httpResponse.statusCode, body: data)))
            }
        }
        
        task.resume()
    }
}
