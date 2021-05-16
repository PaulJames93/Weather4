//
//  WeatherViewController.swift
//  Weather4
//
//  Created by Paul James on 21.03.2021.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    //MARK: IBOutlets
    
    @IBOutlet weak var weatherScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var weatherLocation: WeatherLocation!
    var userDefaults = UserDefaults.standard
    
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocationCoordinate2D!
    
    var allLocaiton: [WeatherLocation] = []
    var allWeatherView: [WeatherView] = []
    var allWeatherData: [CityTempData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManagerStart()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        locationAuthCheck()

//        let weatherView = WeatherView()
//        weatherView.frame = CGRect(x: 0, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
//        scrollView.addSubview(weatherView)
//
//        weatherLocation = WeatherLocation(city: "Moscow", country: "Russia", countryCode: "RU", isCurrentLocation: false)
//
//        getCurrentWeather(weatherView: weatherView)
//        getWeeklyWeather(weatherView: weatherView)
//        getHourlyWeather(weatherView: weatherView)
       
    }
    
    
    //MARK: download weather
    
    private func getWeather() {
        loadLocationFromUserDefaults()
        print("we have \(allLocaiton.count)")
        createWeatherViews()
        addWeatherToScrollView()
    }
    
    private func createWeatherViews() {
        // так мы создадим вью для каждого сохраненного локейшна
        for _ in allLocaiton {
            allWeatherView.append(WeatherView())
        }
    }
    
    private func addWeatherToScrollView() {
        for i in 0..<allWeatherView.count {
            let weatherView = allWeatherView[i]
            let location = allLocaiton[i]
            
            getCurrentWeather(weatherView: weatherView, location: location)
            getWeeklyWeather(weatherView: weatherView, location: location)
            getHourlyWeather(weatherView: weatherView, location: location)
            
            let xPos = self.view.frame.width * CGFloat(i)
            weatherView.frame = CGRect(x: xPos, y: 0, width: weatherScrollView.bounds.width, height: weatherScrollView.bounds.height)
            
            weatherScrollView.addSubview(weatherView)
            weatherScrollView.contentSize.width = weatherView.frame.width * CGFloat(i + 1)
  
        }
    }
    
    private func getCurrentWeather(weatherView: WeatherView, location: WeatherLocation) {
        weatherView.currentWeather = CurrentWeather()
        weatherView.currentWeather.getCurrentWeather(location: weatherLocation) { (success) in
            weatherView.refreshData()
        }
        
    }

    private func getWeeklyWeather(weatherView: WeatherView, location: WeatherLocation) {
        WeeklyWeatherForecast.downloadWeeklyWeatherForecast(location: weatherLocation) { (weatherForecast) in
            weatherView.weeklyWeatherForecastData = weatherForecast
            weatherView.tableView.reloadData()
        }
    
    }
    
    private func getHourlyWeather(weatherView: WeatherView, location: WeatherLocation) {
        HourlyForecast.downloadHourlyForecastWeather(location: weatherLocation) { (weatherForecast) in
            weatherView.dailyWeatherForecastData = weatherForecast
            weatherView.hourlyCollectionView.reloadData()
        }
    }
    
    //MARK: Load from User Defaults
    
    func loadLocationFromUserDefaults() {
        
        let currentLocation = WeatherLocation(city: "", country: "", countryCode: "", isCurrentLocation: true)
        
        if let data = userDefaults.value(forKey: "Locations") as? Data {
            
            allLocaiton = try! PropertyListDecoder().decode(Array<WeatherLocation>.self, from: data)
        
            allLocaiton.insert(currentLocation, at: 0)
        } else {
            print("No user data in userDefaults")
            allLocaiton.append(currentLocation)
        }
    }
    
    
    //MARK:  locationManager
    
    func locationManagerStart() {
        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.requestWhenInUseAuthorization() // штука запрашивает разрешение на отображение геолокации. Если мы это не сделаем, то наше приложение завернут. Сделаем запрос на разрешение в infoPlist
            locationManager!.delegate = self
        }
        locationManager!.startMonitoringSignificantLocationChanges()
    }
    
    private func locationManagerStop() {
        if locationManager != nil {
            locationManager!.stopMonitoringSignificantLocationChanges()
        }
    }
    
    private func locationAuthCheck() {
        
        let manager = CLLocationManager()
        if manager.authorizationStatus == .authorizedWhenInUse {
           
            currentLocation = locationManager!.location?.coordinate
            
            if currentLocation != nil {
                LocationService.shared.latitude = currentLocation.latitude
                LocationService.shared.longitude = currentLocation.longitude
                
                getWeather()

            } else {
                print("STTH wrong")
                locationAuthCheck()
            }
        } else {
            locationManager?.requestWhenInUseAuthorization() //если у нас пользователь не дал разрешение на пользование геолокации мы попросим его снова с помощью вот этой прекрасной строчки - потому что пока нам не дадут разрешение мы не сможем дать ему работающее приложение
            locationAuthCheck()
        }
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Faild to get location, \(error.localizedDescription)")
    }
}
