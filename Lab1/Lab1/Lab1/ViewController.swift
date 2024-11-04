//
//  ViewController.swift
//  Lab1
//
//  Created by Brenna Pavlinchak on 10/31/24.
//

import UIKit

class ViewController: UIViewController
{
    var movies = [Movies]()
    var currentIndex = 0
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieGenreLabel: UILabel!
    @IBOutlet weak var movieYearLabel: UILabel!
    @IBOutlet weak var movieActorsLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        displayMovie(at: currentIndex)
        
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
            for movie in movies
            {
                movie.printMovie()
            }
            
        }
    }
    
    func displayMovie(at index: Int)
    {
        guard index >= 0 && index < movies.count else { return }
        let movies = movies[index]
        movieTitleLabel.text = movies.title
        movieGenreLabel.text = movies.genre
        movieYearLabel.text = movies.year
        movieActorsLabel.text = movies.actors.joined(separator:  ", ")
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
                
                movies.append(Movies(title: movieTitle, genre: movieGenre, year: movieYear, actors: movieActors))
            }
        }
    }
    
    @IBAction func nextMovie(_ sender: UIButton)
    {
        if currentIndex < movies.count - 1 {
            currentIndex += 1
            displayMovie(at: currentIndex)
        }
    }
    
    @IBAction func previousMovie(_ sender: UIButton)
    {
        if currentIndex > 0 {
            currentIndex -= 1
            displayMovie(at: currentIndex)
        }
    }
}

