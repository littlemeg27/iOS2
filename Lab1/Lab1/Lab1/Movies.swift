//
//  Movies.swift
//  Lab1
//
//  Created by Brenna Pavlinchak on 11/2/24.
//

import Foundation

class Movies
{
    let title: String
    let genre: String
    let year: String
    let actors: [String]
    
    var movieTitle: String
    {
        get { return "\(title)"}
    }
    var movieGenre: String
    {
        get { return "\(genre)"}
    }
    var movieYear: String
    {
        get { return "\(year)"}
    }
    var movieActors: String
    {
        get { return movieActors.count.description}
    }
    
    
    init(title: String, genre: String, year: String, actors: [String])
    {
        self.title = title
        self.genre = genre
        self.year = year
        self.actors = actors
    }
    
    func printMovie()
    {
        var printString: String = "Title: \(movieTitle) Genre: \(movieGenre)\" Year: \(movieYear) Actors:"
        
        for actor in actors
        {
            printString += "\n\(actors)"
        }
        print(printString)
    }
}
