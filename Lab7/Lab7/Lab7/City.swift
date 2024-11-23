//
//  City.swift
//  Lab7
//
//  Created by Brenna Pavlinchak on 11/20/24.
//

import Foundation

struct City
{
    let name: String
    let state: String
}

// Load cities from zips.json file
func loadCitiesData() -> [City]
{
    guard let url = Bundle.main.url(forResource: "zips", withExtension: "json"),
          let data = try? Data(contentsOf: url) else
    {
        print("Failed to load zips.json file.")
        return []
    }

    do
    {
        
        guard let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else // Parse JSON using JSONSerialization
        {
            print("Invalid JSON structure.")
            return []
        }

        
        var cities: [City] = [] // Map JSON objects to City structs
        
        for jsonObject in jsonArray
        {
            if let name = jsonObject["city"] as? String,
               let state = jsonObject["state"] as? String
            {
                cities.append(City(name: name, state: state))
            }
        }
        return cities
    }
    catch
    {
        print("Error parsing JSON: \(error)")
        return []
    }
}

