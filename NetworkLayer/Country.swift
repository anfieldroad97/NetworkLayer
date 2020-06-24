//
//  Country.swift
//  NetworkLayer
//
//  Created by Mirzhan Gumarov on 6/23/20.
//  Copyright © 2020 Mirzhan Gumarov. All rights reserved.
//

import Foundation

struct CountryResponse: Decodable {
    var countries: [Country]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nestedContainer = try container.nestedContainer(keyedBy: ResponseCodingKeys.self, forKey: .response)
        
        countries = try nestedContainer.decode([Country].self, forKey: .countries)
    }
    
    private enum CodingKeys: String, CodingKey {
        case response
    }
    
    private enum ResponseCodingKeys: String, CodingKey {
        case countries
    }
}

struct Country: Decodable {
    let countryName: String
    let totalHolidays: Int
}
