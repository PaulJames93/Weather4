//
//  WeatherLocation.swift
//  Weather4
//
//  Created by Paul James on 31.03.2021.
//

import Foundation


struct WeatherLocation: Codable, Equatable {
    var city: String!
    var country: String!
    var countryCode: String!
    var isCurrentLocation: Bool!
    
}
