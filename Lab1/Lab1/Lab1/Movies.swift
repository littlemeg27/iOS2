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
    
    
    init(title: String, genre: String, year: String, actors: [String])
    {
        self.title = title
        self.genre = genre
        self.year = year
        self.actors = actors
    }
}
