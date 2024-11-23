//
//  SettingsViewController.swift
//  Lab8
//
//  Created by Brenna Pavlinchak on 11/20/24.
//

import UIKit

class SettingsViewController: UITableViewController
{
    let themes = ["Light", "Dark", "Blue"]
    var selectedTheme: String = UserDefaults.standard.string(forKey: "selectedTheme") ?? "Light"

    override func viewDidLoad()
    {
        super.viewDidLoad()
        title = "Settings"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return themes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ThemeCell") as! ThemeTableViewCell
        let theme = themes[indexPath.row]
        cell.themeLabel.text = theme
        cell.checkmarkImageView.isHidden = theme != selectedTheme
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        selectedTheme = themes[indexPath.row]
        UserDefaults.standard.set(selectedTheme, forKey: "selectedTheme")
        tableView.reloadData()
    }
}
