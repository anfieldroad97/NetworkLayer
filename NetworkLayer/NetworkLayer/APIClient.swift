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
    private let requestBuilder: RequestBuilder
    
    init(requestBuilder: RequestBuilder) {
        self.requestBuilder = requestBuilder
    }
    
    func perform(_ request: APIRequest, _ completion: @escaping Handler) {
        let urlRequest = requestBuilder.buildRequest(from: request)
        
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
