//
//  APIResult.swift
//  NetworkLayer
//
//  Created by Mirzhan Gumarov on 6/23/20.
//  Copyright © 2020 Mirzhan Gumarov. All rights reserved.
//

import Foundation

enum APIResult<T> {
    case success(T)
    case failure(APIError)
}
