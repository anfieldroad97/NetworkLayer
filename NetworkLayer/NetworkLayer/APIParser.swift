//
//  APIParser.swift
//  NetworkLayer
//
//  Created by Mirzhan Gumarov on 6/24/20.
//  Copyright © 2020 Mirzhan Gumarov. All rights reserved.
//

import Foundation

class APIParser {
    private let decoder: JSONDecoder
    
    init(decoder: JSONDecoder) {
        self.decoder = decoder
    }
    
    func decode<BodyType: Decodable>(data: Data, to type: BodyType.Type) throws -> BodyType {
        return try decoder.decode(BodyType.self, from: data)
    }
}
