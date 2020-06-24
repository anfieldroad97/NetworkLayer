//
//  APIError.swift
//  NetworkLayer
//
//  Created by Mirzhan Gumarov on 6/23/20.
//  Copyright © 2020 Mirzhan Gumarov. All rights reserved.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case requestFailed
    case decodingFailure
    case emptyResponse
}
