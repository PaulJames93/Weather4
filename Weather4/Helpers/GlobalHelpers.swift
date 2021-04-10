//
//  GlobalHelpers.swift
//  Weather4
//
//  Created by Paul James on 20.03.2021.
//

import Foundation
import UIKit

func currentDateFromUnix(unixDate: Double?) -> Date? {
    if unixDate != nil {
        return Date(timeIntervalSince1970: unixDate!)
    } else {
        return Date()
    }
    
}
func getWeatherIconFor(_ type: String) -> UIImage? {
    return UIImage(named: type)
}
