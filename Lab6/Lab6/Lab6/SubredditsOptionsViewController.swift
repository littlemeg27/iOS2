//
//  SubredditsOptionsViewController.swift
//  Lab6
//
//  Created by Brenna Pavlinchak on 11/18/24.
//

import UIKit

class SubredditsOptionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    @IBOutlet weak var tableView: UITableView!
    var subreddits: [String] = []

    override func viewDidLoad()
    {
        super.viewDidLoad()
        subreddits = UserDefaults.standard.stringArray(forKey: "Subreddits") ?? ["iphone"]
    }

    @IBAction func addSubreddit(_ sender: UIButton)
    {
        let alert = UIAlertController(title: "Add Subreddit", message: nil, preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler:
                                        { _ in
            if let subreddit = alert.textFields?.first?.text, !subreddit.isEmpty
            {
                self.subreddits.append(subreddit)
                self.tableView.reloadData()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    @IBAction func saveSubreddits(_ sender: UIButton)
    {
        UserDefaults.standard.set(subreddits, forKey: "Subreddits")
        dismiss(animated: true)
    }

    @IBAction func resetSubreddits(_ sender: UIButton)
    {
        subreddits = ["iphone"]
        UserDefaults.standard.set(subreddits, forKey: "Subreddits")
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return subreddits.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubredditCell", for: indexPath)!
        cell.textLabel?.text = subreddits[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            subreddits.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
