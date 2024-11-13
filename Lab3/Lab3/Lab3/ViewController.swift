//
//  ViewController.swift
//  Lab3
//
//  Created by Brenna Pavlinchak on 11/10/24.
//


import UIKit

class ViewController: UIViewController
{
    var fireBaseInfo = [FireBase]()
    var currentIndex = 0

    @IBOutlet weak var FireBasePhraseLabel: UITextView!
    @IBOutlet weak var FireBaseColorsLabel: UILabel!
    @IBOutlet weak var FireBaseColorLabel: UILabel!
    @IBOutlet weak var FireBaseDescriptionLabel: UILabel!
    @IBOutlet weak var FireBaseRevenueLabel: UILabel!
    @IBOutlet weak var FireBaseNameLabel: UILabel!
    @IBOutlet weak var FireBaseCompanyLabel: UILabel!
    @IBOutlet weak var FireBaseVersionLabel: UILabel!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        if let firstURL = URL(string: "https://fullsailmobile.firebaseio.com/T1NVC.json")
        {
            getData(from: firstURL, session: session)
        }

        if let secondURL = URL(string: "https://fullsailmobile.firebaseio.com/T2CRC.json")
        {
            getData(from: secondURL, session: session)
        }
    }

    func getData(from url: URL, session: URLSession)
    {
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error
            {
                print("Error fetching data from \(url): " + error.localizedDescription)
                return
            }
            print("Success fetching data from \(url)")
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let validData = data else
            {
                print("JSON data is invalid from \(url)")
                return
            }
            
            do
            {
                if let jsonObject = try JSONSerialization.jsonObject(with: validData, options: []) as? [String: Any]
                {
                    self.parseJSON(jsonObject, from: url)
                }
            }
            catch
            {
                print("Error parsing JSON from \(url): " + error.localizedDescription)
            }
        }
        task.resume()
    }

    func parseJSON(_ jsonObject: [String: Any], from url: URL)
    {
        if let name = jsonObject["name"] as? String, //Parse JSON
           let company = jsonObject["company"] as? String,
           let version = jsonObject["version"] as? String,
           let catchPhrase = jsonObject["catch_phrase"] as? String,
           let colorsArray = jsonObject["colors"] as? [[String: Any]],
           let dailyRevenue = jsonObject["daily_revenue"] as? String
        {
            
            let colors = colorsArray.compactMap
            {
                dictionary -> Color? in
                guard let color = dictionary["color"] as? String, let description = dictionary["description"] as? [String] else { return nil }
                return Color(color: color, description: description)
            }
            
            let fireBaseData = FireBase(name: name, company: company, version: version, catch_phrase: catchPhrase, daily_revenue: dailyRevenue, colors: colors)
            self.fireBaseInfo.append(fireBaseData)
            
            DispatchQueue.main.async
            {
                if self.fireBaseInfo.count == 1
                {
                    self.displayFireBase(at: 0)
                }
            }
        }
    }
    
    func displayFireBase(at index: Int)
    {
        guard index >= 0 && index < fireBaseInfo.count else { return }
        
        let fireBaseData = fireBaseInfo[index]
        
        FireBaseNameLabel.text = fireBaseData.name
        FireBaseCompanyLabel.text = fireBaseData.company
        FireBaseVersionLabel.text = fireBaseData.version
        FireBasePhraseLabel.text = fireBaseData.catch_phrase
        FireBaseRevenueLabel.text = fireBaseData.daily_revenue
        
        FireBaseColorsLabel.text = "\(fireBaseData.colors.count)"
        
        if let firstColor = fireBaseData.colors.first
        {
            FireBaseColorLabel.text = firstColor.color
            FireBaseDescriptionLabel.text = firstColor.description.joined(separator: ", ")
        }
        else
        {
            FireBaseColorLabel.text = "No Color"
            FireBaseDescriptionLabel.text = "No Description"
        }
    }
    
    @IBAction func nextFireBase(_ sender: UIButton)
    {
        if currentIndex < fireBaseInfo.count - 1
        {
            currentIndex += 1
            displayFireBase(at: currentIndex)
        }
    }

    @IBAction func previousFireBase(_ sender: UIButton)
    {
        if currentIndex > 0
        {
            currentIndex -= 1
            displayFireBase(at: currentIndex)
        }
    }
}

struct FireBase //FireBase Struct
{
    var name: String
    var company: String
    var version: String
    var catch_phrase: String
    var daily_revenue: String
    var colors: [Color]
}

struct Color //Color Struct
{
    var color: String
    var description: [String]
}
