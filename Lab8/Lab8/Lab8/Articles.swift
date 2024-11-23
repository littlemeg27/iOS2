//
//  Articles.swift
//  Lab8
//
//  Created by Brenna Pavlinchak on 11/20/24.
//

import Foundation

func fetchArticles(source: String, completion: @escaping ([[String: Any]]?) -> Void)
{
    let apiKey = "your_api_key_here"
    let urlString = "https://newsapi.org/v1/articles?source=\(source)&apiKey=\(apiKey)"
    guard let url = URL(string: urlString) else {
        print("Invalid URL.")
        completion(nil)
        return
    }

    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error
        {
            print("Error fetching articles: \(error)")
            completion(nil)
            return
        }
        guard let data = data else
        {
            print("No data received.")
            completion(nil)
            return
        }
        do
        {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let articles = json["articles"] as? [[String: Any]]
            {
                completion(articles)
            }
            else
            {
                print("Invalid JSON structure.")
                completion(nil)
            }
        }
        catch
        {
            print("JSON parsing error: \(error)")
            completion(nil)
        }
    }
    task.resume()
}
