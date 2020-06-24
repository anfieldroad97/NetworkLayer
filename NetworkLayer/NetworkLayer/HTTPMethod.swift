//
//  HTTPMethod.swift
//  NetworkLayer
//
//  Created by Mirzhan Gumarov on 6/23/20.
//  Copyright © 2020 Mirzhan Gumarov. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case put = "PUT"
    case head = "HEAD"
    case options = "OPTIONS"
    case trace = "TRACE"
    case connect = "CONNECT"
}
