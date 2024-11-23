//
//  ThemeOptionsViewController.swift
//  Lab6
//
//  Created by Brenna Pavlinchak on 11/18/24.
//

import UIKit

class ThemeOptionsViewController: UIViewController
{
    
    @IBOutlet weak var tableViewColorPicker: UIButton!
    @IBOutlet weak var cellColorPicker: UIButton!
    @IBOutlet weak var textColorPicker: UIButton!
    
    var tableViewColor: UIColor?
    var cellColor: UIColor?
    var textColor: UIColor?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        loadSavedPreferences()
    }
    
    @IBAction func saveTheme(_ sender: UIButton)
    {
        UserDefaults.standard.setColor(tableViewColor, forKey: "TableViewColor")
        UserDefaults.standard.setColor(cellColor, forKey: "CellColor")
        UserDefaults.standard.setColor(textColor, forKey: "TextColor")
        dismiss(animated: true)
    }
    
    @IBAction func resetTheme(_ sender: UIButton)
    {
        UserDefaults.standard.removeObject(forKey: "TableViewColor")
        UserDefaults.standard.removeObject(forKey: "CellColor")
        UserDefaults.standard.removeObject(forKey: "TextColor")
        dismiss(animated: true)
    }
    
    private func loadSavedPreferences()
    {
        tableViewColor = UserDefaults.standard.color(forKey: "TableViewColor") ?? .white
        cellColor = UserDefaults.standard.color(forKey: "CellColor") ?? .white
        textColor = UserDefaults.standard.color(forKey: "TextColor") ?? .black
    }
}

extension UserDefaults
{
    func setColor(_ color: UIColor?, forKey key: String)
    {
        if let color = color
        {
            let colorData = try? NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
            set(colorData, forKey: key)
        }
    }
    
    func color(forKey key: String) -> UIColor?
    {
        if let data = data(forKey: key)
        {
            return try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)
        }
        return nil
    }
}

