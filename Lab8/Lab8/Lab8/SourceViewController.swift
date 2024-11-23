//
//  SourceViewController.swift
//  Lab8
//
//  Created by Brenna Pavlinchak on 11/20/24.
//

import UIKit

class SourceViewController: UITableViewController
{
    var sources: [[String: Any]] = []
    var groupedSources: [String: [[String: Any]]] = [:]
    var categories: [String] = []

    @IBOutlet weak var settingsButton: UIBarButtonItem!  // IBOutlet for the settings button

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sources"
        setupToolbar()

        groupedSources = Dictionary(grouping: sources, by: { $0["category"] as? String ?? "Unknown" }) // Group sources by category
        categories = groupedSources.keys.sorted()
    }

    @IBAction func openSettings(_ sender: UIBarButtonItem)
    {
        let settingsVC = SettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }

    private func setupToolbar()
    {
        let settingsButton = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(openSettings(_:)))
        toolbarItems = [settingsButton]
        navigationController?.isToolbarHidden = false
    }

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let category = categories[section]
        return groupedSources[category]?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SourceCell") ?? UITableViewCell(style: .default, reuseIdentifier: "SourceCell")
        let category = categories[indexPath.section]
        
        if let source = groupedSources[category]?[indexPath.row]
        {
            cell.textLabel?.text = source["name"] as? String
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let category = categories[indexPath.section]
        
        if let source = groupedSources[category]?[indexPath.row], let sourceId = source["id"] as? String
        {
            let articlesVC = ArticleViewController()
            articlesVC.sourceId = sourceId
            articlesVC.title = source["name"] as? String
            navigationController?.pushViewController(articlesVC, animated: true)
        }
    }
}
