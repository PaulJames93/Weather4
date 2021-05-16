//
//  APIURLS.swift
//  Weather4
//
//  Created by Paul James on 05.04.2021.
//

import Foundation


let CURRENTLOCATION_URL = "https://api.weatherbit.io/v2.0/current?lat=\(LocationService.shared.latitude!)&lon=\(LocationService.shared.longitude!)&key=d6bf5dfc87c541958a268f3074b4b2d8"
let CURRENTLOCATIONWEEKLYFORECAST_URL = "https://api.weatherbit.io/v2.0/forecast/daily?lat=\(LocationService.shared.latitude!)&lon=\(LocationService.shared.longitude!)days=7&key=d6bf5dfc87c541958a268f3074b4b2d8"
let CURRENTLOCATIONHOURLYFORECAST_URL = "https://api.weatherbit.io/v2.0/forecast/hourly?lat=\(LocationService.shared.latitude!)&lon=\(LocationService.shared.longitude!)&hours=24&key=d6bf5dfc87c541958a268f3074b4b2d8"
