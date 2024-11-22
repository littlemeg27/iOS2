//
//  DetailViewController.swift
//  Lab5
//
//  Created by Brenna Pavlinchak on 11/18/24.
//

import UIKit

class DetailViewController: UIViewController
{
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var partyLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var member: Member?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        guard let member = member else { return }
        nameLabel.text = "\(member.firstName) \(member.lastName)"
        partyLabel.text = "Party: \(member.party)"
        titleLabel.text = "Title: \(member.title)"
        stateLabel.text = "State: \(member.state)"
        
        if let imageUrl = URL(string: "https://api.congress.gov/members/\(member.id)/image/225x275")
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
                else
                {
                    DispatchQueue.main.async
                    {
                        cell.thumbnailImageView.image = UIImage(named: "placeholder") // Use a placeholder image
                    }
                }
            }
        }
    }
}
