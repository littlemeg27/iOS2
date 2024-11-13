//
//  ViewController.swift
//  Lab4
//
//  Created by Brenna Pavlinchak on 11/11/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{

    var posts = [RedditPost]()

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        if let url = URL(string: "https://www.reddit.com/r/iphone/.json")
        {
            getData(from: url, session: session)
        }
    }

    func getData(from url: URL, session: URLSession)
    {
        let task = session.dataTask(with: url)
        {
            data, response, error in
            
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
                if let jsonObject = try JSONSerialization.jsonObject(with: validData, options: []) as? [String: Any],
                   let dataObject = jsonObject["data"] as? [String: Any],
                   let childrenArray = dataObject["children"] as? [[String: Any]]
                {
                    self.parseJSON(childrenArray)
                }
            }
            catch
            {
                print("Error parsing JSON from \(url): " + error.localizedDescription)
            }
        }
        task.resume()
    }

    func parseJSON(_ childrenArray: [[String: Any]])
    {
        for postData in childrenArray {
            if let post = postData["data"] as? [String: Any], let title = post["title"] as? String, let thumbnail = post["thumbnail"] as? String, !thumbnail.isEmpty
            {
                let redditPost = RedditPost(title: title, thumbnail: thumbnail)
                self.posts.append(redditPost)
            }
        }
        
        DispatchQueue.main.async
        {
            self.tableView.reloadData() // Reload table view
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
        let post = posts[indexPath.row] // Dequeue the custom cell
        
        cell.titleLabel.text = post.title // Set the title
        
        
        if let url = URL(string: post.thumbnail) // Load the thumbnail image
        {
            
            DispatchQueue.global().async // Fetch image data 
            {
                if let data = try? Data(contentsOf: url)
                {
                    DispatchQueue.main.async
                    {
                        if let image = UIImage(data: data)
                        {
                            cell.thumbnailImageView.image = image
                        }
                    }
                }
            }
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        // Handle cell selection if necessary
    }
}

struct RedditPost
{
    var title: String
    var thumbnail: String
}
