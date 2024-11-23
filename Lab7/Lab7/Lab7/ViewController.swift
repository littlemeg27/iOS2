//
//  ViewController.swift
//  Lab7
//
//  Created by Brenna Pavlinchak on 11/20/24.
//

import UIKit

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var tableView: UITableView!

    var allCities: [City] = [] // Holds all the cities data
    var filteredCities: [City] = [] // Holds filtered results from Search View

    override func viewDidLoad()
    {
        super.viewDidLoad()

        
        allCities = loadCitiesData() // Dynamically load cities from zips.json

        // Configure the tableView
        tableView.delegate = self
        tableView.dataSource = self
    }

    
    @IBAction func searchButtonTapped(_ sender: UIBarButtonItem) // Action for Search button
    {
        let searchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        searchVC.delegate = self
        searchVC.allCities = allCities
        navigationController?.pushViewController(searchVC, animated: true)
    }

    // Action for Clear button
    @IBAction func clearButtonTapped(_ sender: UIBarButtonItem)
    {
        filteredCities.removeAll()
        tableView.reloadData()
    }
}

extension ViewController: SearchViewControllerDelegate // MARK: - SearchViewControllerDelegate
{
    func didReturnSearchResults(_ results: [City])
    {
        filteredCities = results
        tableView.reloadData()
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return filteredCities.isEmpty ? allCities.count : filteredCities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let city = filteredCities.isEmpty ? allCities[indexPath.row] : filteredCities[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)
        cell.textLabel?.text = city.name
        return cell
    }
}
