//
//  WeeklyWeatherForecast.swift
//  Weather4
//
//  Created by Paul James on 21.03.2021.
//

import Foundation
import Alamofire
import SwiftyJSON

class WeeklyWeatherForecast {
    
    private var _date: Date!
    private var _temp: Double!
    private var _weatherIcon: String!
    
    var date: Date {
        if _date == nil {
            _date = Date()
        }
        return _date
    }
    
    var temp: Double {
        if _temp == nil {
            _temp = 0.0
        }
        return _temp
    }
    
    var weatherIcon: String {
        if _weatherIcon == nil {
            _weatherIcon = ""
        }
        return _weatherIcon
    }
    
    // инициализатор
    init(weatherDictionary: Dictionary<String, AnyObject>) {
        let json = JSON(weatherDictionary)
        
        self._temp = json["temp"].double
        self._date = currentDateFromUnix(unixDate: json["ts"].double!) //так мы прописываем дату, тк нужно конвертнуть из unix
        self._weatherIcon = json["weather"]["icon"].stringValue
    }
    
    class func downloadWeeklyWeatherForecast(location: WeatherLocation, completion: @escaping (_ weatherForecast:[WeeklyWeatherForecast]) -> Void) {
        
        
        var WEEKLYFORECAST_URL: String!
        if !location.isCurrentLocation {
            WEEKLYFORECAST_URL = String(format: "https://api.weatherbit.io/v2.0/forecast/daily?city=%@,%@&days=7&key=d6bf5dfc87c541958a268f3074b4b2d8", location.city, location.countryCode)
        } else {
            WEEKLYFORECAST_URL = CURRENTLOCATIONWEEKLYFORECAST_URL
        }
        
        AF.request(WEEKLYFORECAST_URL).responseJSON { (response) in
            
            var forecastArray: [WeeklyWeatherForecast] = []
            
            switch response.result {
            case .success(var json):
                json = JSON(response.data!)
                
                if let dictionary = response.value as? Dictionary<String, AnyObject> {
                    if var list = dictionary["data"] as? [Dictionary<String, AnyObject>] {
                        //здесь нужно внимательно смотреть как извлекать, тк нам нужно извлечь только 6 дней, тк за сегодня у нас отвечает апи currentDay.
                        list.remove(at: 0) // remove current day
//                        print("number of days", list.count)
                        
                        for item in list {
                            let forecast = WeeklyWeatherForecast(weatherDictionary: item)
                            forecastArray.append(forecast)
                        }
                    }
                }
                
                
                completion(forecastArray)
            case.failure(let error):
                completion(forecastArray)
                print("It's en error", error.localizedDescription)
            }
            
        }
        
    }
    
    
}
