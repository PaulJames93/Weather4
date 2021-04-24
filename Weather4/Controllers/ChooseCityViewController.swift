//
//  ChooseCityViewController.swift
//  Weather4
//
//  Created by Paul James on 08.04.2021.
//

import UIKit

protocol ChooseCityViewControllerDelegate {
    func didAdd(newLocation: WeatherLocation)
}

class ChooseCityViewController: UIViewController {
    
    //MARK: Outlets

    @IBOutlet weak var tableView: UITableView!
    
    var allLocations: [WeatherLocation] = []
    var filteredLocatons: [WeatherLocation] = []
    
    let userDefaults = UserDefaults.standard
    var savedLocation: [WeatherLocation]?
    
    let searchController = UISearchController(searchResultsController: nil)
    var delegate: ChooseCityViewControllerDelegate?
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadFromUserDefaults()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView() //так мы уберем весь бэк и сепараторы
        setupSearchController()
        tableView.tableHeaderView = searchController.searchBar
        loadLocationsFromCSV()
        
        setupTapGesture()
    }
    
    
    
    private func setupSearchController() {
        searchController.searchBar.placeholder = "City or Country"
        searchController.searchBar.searchTextField.backgroundColor = .white
        searchController.searchResultsUpdater = self //наш вью будет обновляться вне зависимости от того чтобы мы искали
        searchController.dimsBackgroundDuringPresentation = false //является ли базовое содержимое затемненным во время поиска
        definesPresentationContext = true
        
        searchController.searchBar.searchBarStyle = UISearchBar.Style.prominent //так у нас серч бар всегда будет видимый. То есть в обычном сценарии(когда нет навигейшена) у нас серчБар появляется после того как мы проводим вниз. А так у нас он всегда будет
        
        searchController.searchBar.sizeToFit() // размер нашего серчБара будет подстраиваться под размер вью
        searchController.searchBar.backgroundImage = UIImage() //если этого не будет, то хэдер вокруг серчБара у нас будет серая что нам не надо - нам нужна пустая обычная область - поэтому мы так написал и
        
    }
    
    private func setupTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tableTapped))
        self.tableView.backgroundView = UIView()
        self.tableView.backgroundView?.addGestureRecognizer(tap) //добавили тап на возврат
    }
    
    @objc func tableTapped() {
        //тут логика такая же: если у нас контроллер мы дисмис если нет мы дисмис
        dismissView()
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
//        print(allLocations.count)
    }
    
    
    //MARK: UserDefaults
    
    private func saveToUserDefaults(location: WeatherLocation) {
        //если у нас существует локация пользователя
        if savedLocation != nil {
            
            
            //а это если у нас не существует в сейвдлокейшен локация пользоватял, то мы хотим добавить эту локацию
            if !savedLocation!.contains(location) {
                savedLocation!.append(location)
            }
            
        } else {
            //если у нас нет локаци то что на мнадо сделать чтобы сохранить локацию
            savedLocation = [location]
            
        }
        
        userDefaults.set(try? PropertyListEncoder().encode(savedLocation!), forKey: "Locations")
        userDefaults.synchronize()
    }
    //нам нужен loadFromUserDefaults  для того чтобы проверять существует ли уже этот объект или нужно его сохранять
    private func loadFromUserDefaults() {
        //тут нам нужно сначала понять есть у нас что-то в юзер дефолтс или нет
        if let data = userDefaults.value(forKey: "Locations") as? Data {
            savedLocation = try? PropertyListDecoder().decode(Array<WeatherLocation>.self, from: data)
            print(savedLocation?[1].city)
        }
    }
 
    private func dismissView() {
        if searchController.isActive {
            searchController.dismiss(animated: true) {
                self.dismiss(animated: true)
            }
        } else {
            self.dismiss(animated: true)
        }
    }
    
}

extension ChooseCityViewController: UISearchResultsUpdating {
    //этот метод будет показывать нам что мы ищем
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredLocatons = allLocations.filter({ (location) -> Bool in
            
            return location.city.lowercased().contains(searchText.lowercased()) || location.country.lowercased().contains(searchText.lowercased()) //так мы сделали что все вбиваемые буквы будут маленьики
        })
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
   
}

extension ChooseCityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredLocatons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let location = filteredLocatons[indexPath.row]
        cell.textLabel?.text = location.city
        cell.detailTextLabel?.text = location.country
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        saveToUserDefaults(location: filteredLocatons[indexPath.row])
        
        delegate?.didAdd(newLocation: filteredLocatons[indexPath.row])
        
        dismissView()
    }
 
}
