//
//  ViewController.swift
//  Lab4
//
//  Created by Brenna Pavlinchak on 11/11/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{

    var posts = [RedditPost]() // Updated to use the refactored class

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
            if let post = postData["data"] as? [String: Any],
               let title = post["title"] as? String,
               let thumbnail = post["thumbnail"] as? String,
               let author = post["author"] as? String,
               let urlComponents = URLComponents(string: thumbnail),
               let scheme = urlComponents.scheme, scheme.lowercased() == "https" || scheme.lowercased() == "http"
            {
                // Creating a valid RedditPost instance and adding it to the posts array
                let redditPost = RedditPost(title: title, thumbnail: thumbnail, author: author)
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
        cell.thumbnailImageView.image = nil // Reset the image view
        
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
    
    func setupToolbar()
    {
        let toolbar = UIToolbar()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toolbar)

        let themeButton = UIBarButtonItem(title: "Theme", style: .plain, target: self, action: #selector(openThemeOptions))
        let subredditsButton = UIBarButtonItem(title: "Subreddits", style: .plain, target: self, action: #selector(openSubredditsOptions))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        toolbar.items = [themeButton, flexSpace, subredditsButton]

        NSLayoutConstraint.activate([
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbar.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc func openThemeOptions()
    {
        performSegue(withIdentifier: "ShowThemeOptions", sender: self)
    }

    @objc func openSubredditsOptions()
    {
        performSegue(withIdentifier: "ShowSubredditsOptions", sender: self)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        applyThemePreferences()
        reloadSubreddits()
    }

    func applyThemePreferences()
    {
        tableView.backgroundColor = UserDefaults.standard.color(forKey: "TableViewColor") ?? .white
        tableView.reloadData()
    }

    func reloadSubreddits()
    {
        let subreddits = UserDefaults.standard.stringArray(forKey: "Subreddits") ?? ["iphone"]
        posts.removeAll()

        for subreddit in subreddits
        {
            if let url = URL(string: "https://www.reddit.com/r/\(subreddit)/.json")
            {
                getData(from: url, session: URLSession.shared)
            }
        }
    }
}

class RedditPost
{
    var title: String
    var thumbnail: String
    var author: String

    init(title: String, thumbnail: String, author: String)
    {
        self.title = title
        self.thumbnail = thumbnail
        self.author = author
    }
}
