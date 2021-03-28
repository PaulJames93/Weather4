//
//  HourlyForecast.swift
//  Weather4
//
//  Created by Paul James on 21.03.2021.
//

import Foundation
import Alamofire
import SwiftyJSON

class HourlyForecast {
    
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
    
    //почасовой инициализатор
    init(weatherDictionary: Dictionary<String, AnyObject>) {
        let json = JSON(weatherDictionary)
        
        self._temp = json["temp"].double
        self._date = currentDateFromUnix(unixDate: json["ts"].double!) //так мы прописываем дату, тк нужно конвертнуть из unix
        self._weatherIcon = json["weather"]["icon"].stringValue
    }
    
    class func downloadHourlyForecastWeather(completion: @escaping (_ hourlyForecast: [HourlyForecast]) -> Void) {
        
        let HOURLYFORECAST_URL = "https://api.weatherbit.io/v2.0/forecast/hourly?lat=59.9386300&lon=30.3141300&hours=24&key=d6bf5dfc87c541958a268f3074b4b2d8"
        
        AF.request(HOURLYFORECAST_URL).responseJSON { (response) in
            var forecastArray:[HourlyForecast] = []
            
            switch response.result {
            case .success(var json):
                json = JSON(response.data!)
//                print("result is:", response.value)
                if let dictionary = response.value as? Dictionary<String, AnyObject> {
                    if let list = dictionary["data"] as? [Dictionary<String, AnyObject>] {
                        //далее мы перебираем каждую дату через цикл
                        for item in list {
                            let forecast = HourlyForecast(weatherDictionary: item)
                            forecastArray.append(forecast)
                        }
                    }
                }
                completion(forecastArray)
                
            case .failure(let error):
                completion(forecastArray)
                print("This is error", error.localizedDescription)
            }
        }
    }
}
