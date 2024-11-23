//
//  SearchViewController.swift
//  Lab7
//
//  Created by Brenna Pavlinchak on 11/20/24.
//

import UIKit

protocol SearchViewControllerDelegate: AnyObject
{
    func didReturnSearchResults(_ results: [City])
}

class SearchViewController: UIViewController
{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var allCities: [City] = []  // All cities data
    var filteredCities: [City] = []  // Filtered cities based on search
    var selectedState: String = "All"  // Initially shows all cities
    
    weak var delegate: SearchViewControllerDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
       
        allCities = loadCitiesData()  // Initializing the cities data (you can replace this with your own data)
        
        searchBar.delegate = self
        searchBar.scopeButtonTitles = ["All", "California", "Texas"]
        tableView.delegate = self
        tableView.dataSource = self
    }
    
   
    @IBAction func scopeChanged(_ sender: UISegmentedControl)  // Action to handle scope change
    {
        selectedState = searchBar.scopeButtonTitles?[sender.selectedSegmentIndex] ?? "All"
        filterCities()
    }
    
    func filterCities() // Filtering cities based on the selected scope and search text
    {
        var result = allCities
        
        if selectedState != "All" // Filter by state if a specific state is selected
        {
            result = result.filter { $0.state == selectedState }
        }
        
        if let searchText = searchBar.text, !searchText.isEmpty // Filter by search text
        {
            result = result.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        
        filteredCities = result
        tableView.reloadData()
    }
    
    // Action to return results to Results View
    @IBAction func returnSearchResults(_ sender: UIBarButtonItem)
    {
        delegate?.didReturnSearchResults(filteredCities)
        navigationController?.popViewController(animated: true)
    }
}

extension SearchViewController: UISearchBarDelegate // MARK: - UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        filterCities()
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource // MARK: - UITableViewDelegate and UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return filteredCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let city = filteredCities[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)
        cell.textLabel?.text = city.name
        return cell
    }
}
