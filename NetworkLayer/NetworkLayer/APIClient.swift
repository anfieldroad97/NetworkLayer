//
//  APIClient.swift
//  NetworkLayer
//
//  Created by Mirzhan Gumarov on 6/23/20.
//  Copyright © 2020 Mirzhan Gumarov. All rights reserved.
//

import Foundation

final class APIClient {
    private let session: URLSession
    private let requestBuilder: RequestBuilder
    private let parser: APIParser
    
    init(session: URLSession, requestBuilder: RequestBuilder, parser: APIParser) {
        self.session = session
        self.requestBuilder = requestBuilder
        self.parser = parser
    }
    
    func perform<T: Decodable>(_ request: APIRequest, _ completion: @escaping (APIResult<T>) -> Void) {
        let urlRequest = requestBuilder.buildRequest(from: request)
        
        let task = session.dataTask(with: urlRequest) { [weak self] (data, response, error) in
            guard let _ = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(.requestFailed));
                }
                
                return
            }
            
            DispatchQueue.main.async {
                if let unwrappedData = data, let parser = self?.parser {
                    do {
                        let decodedResponse = try parser.decode(data: unwrappedData, to: T.self)
                        completion(.success(decodedResponse))
                    } catch {
                        completion(.failure(APIError.decodingFailure))
                    }
                    
                } else {
                    completion(.failure(APIError.emptyResponse))
                }
            }
        }
        
        task.resume()
    }
}
