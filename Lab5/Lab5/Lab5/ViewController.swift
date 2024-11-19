//
//  ViewController.swift
//  Lab5
//
//  Created by Brenna Pavlinchak on 11/16/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{

    var posts = [Member]()  // Use the correct struct name here

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let config = URLSessionConfiguration.default // Create URL session
        let session = URLSession(configuration: config)
        
        let apiKey = "QtGLst0ey03ozgphZPcOL7faxMXwh63RcqlO0tbT" // API key here
        
        if let url = URL(string: "https://api.congress.gov/v3/member?format=json&currentMember=true&api_key=\(apiKey)") //Corrected API URL
        {
            getData(from: url, session: session)
        }
    }

    func getData(from url: URL, session: URLSession)
    {
        var request = URLRequest(url: url)
        
        request.addValue("QtGLst0ey03ozgphZPcOL7faxMXwh63RcqlO0tbT", forHTTPHeaderField: "X-Api-Key") //Add API Key in the request header
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error
            {
                print("Error fetching data: \(error.localizedDescription)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let validData = data else
            {
                print("Invalid response or data")
                return
            }

            do
            {
                if let jsonObject = try JSONSerialization.jsonObject(with: validData, options: []) as? [String: Any],
                   let results = jsonObject["results"] as? [[String: Any]]
                {
                    self.parseJSON(results)
                }
            }
            catch
            {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }
        task.resume()
    }

    func parseJSON(_ results: [[String: Any]])
    {
        for result in results
        {
            if let id = result["id"] as? String,
               let firstName = result["first_name"] as? String,
               let lastName = result["last_name"] as? String,
               let title = result["title"] as? String,
               let party = result["party"] as? String,
               let state = result["state"] as? String
            {
                let member = Member(id: id, firstName: firstName, lastName: lastName, title: title, party: party, state: state)
                self.posts.append(member)
            }
        }

        DispatchQueue.main.async
        {
            self.tableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int // UITableViewDataSource method to provide the number of rows
    {
        return posts.count  // Return the count of posts
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! DetailViewController
        let member = posts[indexPath.row]

        cell.titleLabel.text = "\(member.firstName) \(member.lastName)"
        cell.subtitleLabel.text = "\(member.title) - \(member.party)"

        if let imageUrl = URL(string: "https://api.congress.gov/members/\(member.id)/image/225x275") // Asynchronously load images
        {
            DispatchQueue.global().async
            {
                if let data = try? Data(contentsOf: imageUrl)
                {
                    DispatchQueue.main.async
                    {
                        cell.thumbnailImageView.image = UIImage(data: data)
                    }
                }
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let selectedMember = posts[indexPath.row]
        performSegue(withIdentifier: "ShowDetail", sender: selectedMember)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) // Prepare for segue to the detail view
    {
        if segue.identifier == "ShowDetail",
           let detailVC = segue.destination as? DetailViewController,
           let member = sender as? Member
        {
            detailVC.member = member
        }
    }
}

struct Member // Member struct to hold data for each congress member
{
    let id: String
    let firstName: String
    let lastName: String
    let title: String
    let party: String
    let state: String
}
