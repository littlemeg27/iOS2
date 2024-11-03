//
//  ViewController.swift
//  Lab1
//
//  Created by Brenna Pavlinchak on 10/31/24.
//

import UIKit

class ViewController: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let path = Bundle.main.path(forResource: "Movies", ofType: ".json")
        {
            let url = URL(fileURLWithPath: path)
            
            do
            {
                let data = try Data.init(contentsOf: url)
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [Any]
                
                ParseJSON(jsonObject: jsonObject)
            }
            catch
            {
                print(error.localizedDescription)
            }
        }
    }

    func ParseJSON(jsonObject: [Any]?)
    {
        if let jsonObject = jsonObject
        {
            for firstItem in jsonObject
            {
                guard let object = firstItem as? [String: Any],
                let movieTitle = object["title"] as? String,
                let movieYear = object["year"] as? String,
                let movieGenre = object["genre"] as? String,
                let movieActors = object["actors"] as? [String]
                        else { continue }
                
                
            }
        }
    }
    

}

