//
//  WeatherTableViewCell.swift
//  Weather4
//
//  Created by Paul James on 27.03.2021.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    //MARK: IBOutlets
    @IBOutlet weak var dayOfTheWeekLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //метод который будет брать инфмаорцию по погоде на каждый день
    func generateCell(forecast: WeeklyWeatherForecast) {
        //для даты мы пишемотдельный метод в расширении
        dayOfTheWeekLabel.text = forecast.date.dayOfTheWeek()
        weatherIconImageView.image = getWeatherIconFor(forecast.weatherIcon)
        tempLabel.text = "\(forecast.temp)"
    }
    
}
