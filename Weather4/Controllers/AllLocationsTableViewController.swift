//
//  AllLocationsTableViewController.swift
//  Weather4
//
//  Created by Paul James on 08.04.2021.
//

import UIKit

class AllLocationsTableViewController: UITableViewController {
    
    var savedLocation:[WeatherLocation]?
    let userDefaults = UserDefaults.standard
    var weatherData: [CityTempData]?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadFromUserDefaults()
        
    }

    // MARK: - Table view data source

   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return weatherData?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainWeatherTableViewCell
        if weatherData != nil {
            //так у нас генерируется ячейка
            cell.generateCell(weatherData: weatherData![indexPath.row])
        }

        return cell
    }
    
    //MARK: TableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    //ожидает от нас инфу можем мы редактировать или нет. У нас есть первая ячейка которая представляет текущую локацию и мы не должны ее удалять. Мы просто говорим, что можно рддакиировать все что не первая сторчка
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row != 0
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let locationToDelete = weatherData?[indexPath.row]
            weatherData?.remove(at: indexPath.row)
            
            
            //delete from user defaults
            removeLocationFromSavedLoactions(location: locationToDelete!.city)
            tableView.reloadData()
        }
    }
    
    private func removeLocationFromSavedLoactions(location: String) {
        
        if savedLocation != nil {
            for i in 0..<savedLocation!.count {
                let tempLocation = savedLocation![i]
                
                if tempLocation.city == location {
                    savedLocation!.remove(at: i)
                    saveNewLocationsToUserDefaults()
                   
                    return
                }
            }
        }
    }
    //так у нас сохраняется все в нашем  userDefaults 
    private func  saveNewLocationsToUserDefaults() {
        userDefaults.set(try? PropertyListEncoder().encode(savedLocation!), forKey: "Locations")
        userDefaults.synchronize()
    }
    
    //MARK: UserDefaults
    
    private func loadFromUserDefaults() {
        if let data = userDefaults.value(forKey: "Locations") as? Data {
            savedLocation = try? PropertyListDecoder().decode(Array<WeatherLocation>.self, from: data)
            print("We have \(savedLocation!.count) locations in UD")
        }
    }
    
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chooseLocationSegue"{
            let vc = segue.destination as! ChooseCityViewController
            vc.delegate = self
        }
    }
}

extension AllLocationsTableViewController: ChooseCityViewControllerDelegate {
    func didAdd(newLocation: WeatherLocation) {
        print("We have added new location", newLocation.country, newLocation.city)
    }
}
