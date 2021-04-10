//
//  ChooseCityViewController.swift
//  Weather4
//
//  Created by Paul James on 08.04.2021.
//

import UIKit

class ChooseCityViewController: UIViewController {
    
    //MARK: Outlets

    @IBOutlet weak var tableView: UITableView!
    
    var allLocations: [WeatherLocation] = []
    var filteredLocatons: [WeatherLocation] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView() //так мы уберем весь бэк и сепараторы
        setupSearchController()
        tableView.tableHeaderView = searchController.searchBar
        loadLocationsFromCSV()
    }
    
    private func setupSearchController() {
        searchController.searchBar.placeholder = "City or Country"
        searchController.searchBar.searchTextField.backgroundColor = .white
//        searchController.searchResultsUpdater = self //наш вью будет обновляться вне зависимости от того чтобы мы искали
        searchController.dimsBackgroundDuringPresentation = false //является ли базовое содержимое затемненным во время поиска
        definesPresentationContext = true
        
        searchController.searchBar.searchBarStyle = UISearchBar.Style.prominent //так у нас серч бар всегда будет видимый. То есть в обычном сценарии(когда нет навигейшена) у нас серчБар появляется после того как мы проводим вниз. А так у нас он всегда будет
        
        searchController.searchBar.sizeToFit() // размер нашего серчБара будет подстраиваться под размер вью
        searchController.searchBar.backgroundImage = UIImage() //если этого не будет, то хэдер вокруг серчБара у нас будет серая что нам не надо - нам нужна пустая обычная область - поэтому мы так написал и
        
    }
    
//MARK: Get locations
    
    private func loadLocationsFromCSV() {
        
        if let path = Bundle.main.path(forResource: "locations", ofType: "csv") {
            //если путь существует то мы вызываем функцию parseCSV и парсим
            parseCSV(url: URL(fileURLWithPath: path))
        }
        
    }
    
    private func parseCSV(url: URL) {
        
        do {
            
            let data = try Data(contentsOf: url)
            let dataEncoded = String(data: data, encoding: .utf8)
            //далее мы уже можем парсить. У него только city, country, countryCode - у меня чуть больше. Первая линия - не локация а заголовки столбцов. Далее нам нужно делать три разных массива для города страны и кода.
            
            if let dataArr = dataEncoded?.components(separatedBy: "\n").map({$0.components(separatedBy: ",")}) {
                
                var i = 0
                
                for line in dataArr {
                    if line.count > 2 && i != 0 {
                        createLocation(line: line)
                    }
                    i += 1
                }
            }
            
        } catch {
            print("Error reading CVS file", error.localizedDescription)
        }
        
    }
    
    private func createLocation(line: [String]) {
        //тут мы будем подставлять в инициализатор данные в массиве по порядку. Нас интересует город, страна, код страны. Текущая ли локация - ставим фолс так как это не так
        
        allLocations.append(WeatherLocation(city: line[1], country: line[4], countryCode: line[3], isCurrentLocation: false))
        print(allLocations.count)
    }
 

}

extension ChooseCityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredLocatons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //save location
    }
 
}
