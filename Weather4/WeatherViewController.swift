//
//  WeatherViewController.swift
//  Weather4
//
//  Created by Paul James on 21.03.2021.
//

import UIKit

class WeatherViewController: UIViewController {
    
    //MARK: IBOutlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewDidAppear(_ animated: Bool) {

        let weatherView = WeatherView()
        weatherView.frame = CGRect(x: 0, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
        scrollView.addSubview(weatherView)
        
        getCurrentWeather(weatherView: weatherView)
        getWeeklyWeather(weatherView: weatherView)
        getHourlyWeather(weatherView: weatherView)
       
    }
    
    
    //MARK: download weather
    
    private func getCurrentWeather(weatherView: WeatherView) {
        weatherView.currentWeather = CurrentWeather()
        weatherView.currentWeather.getCurrentWeather { (success) in
            weatherView.refreshData()
        }
        
    }

    private func getWeeklyWeather(weatherView: WeatherView) {
        WeeklyWeatherForecast.downloadWeeklyWeatherForecast { (weatherForecast) in
            weatherView.weeklyWeatherForecastData = weatherForecast
            weatherView.tableView.reloadData()
        }
    
    }
    
    private func getHourlyWeather(weatherView: WeatherView) {
        HourlyForecast.downloadHourlyForecastWeather { (weatherForecast) in
            weatherView.dailyWeatherForecastData = weatherForecast
            weatherView.hourlyCollectionView.reloadData()
        }
    }
}
