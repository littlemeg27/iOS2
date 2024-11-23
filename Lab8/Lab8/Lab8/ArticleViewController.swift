//
//  ArticleViewController.swift
//  Lab8
//
//  Created by Brenna Pavlinchak on 11/20/24.
//

import UIKit

class ArticleViewController: UITableViewController
{
    var sourceId: String?
    var articles: [[String: Any]] = []

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!  // IBOutlet for the spinner

    override func viewDidLoad()
    {
        super.viewDidLoad()
        title = sourceId
        
        activityIndicator.startAnimating() // Start loading animation

        fetchArticles(source: sourceId ?? "") { [weak self] fetchedArticles in
            DispatchQueue.main.async
            {
                self?.articles = fetchedArticles ?? []
                self?.tableView.reloadData()
                
                self?.activityIndicator.stopAnimating() // Stop loading animation once articles are fetched
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return articles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "ArticleCell")
        let article = articles[indexPath.row]
        cell.textLabel?.text = article["title"] as? String
        cell.detailTextLabel?.text = article["description"] as? String
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let article = articles[indexPath.row]
        let detailVC = ArticleDetailViewController()
        detailVC.article = article
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
