//
//  ArticleDetailViewController.swift
//  Lab8
//
//  Created by Brenna Pavlinchak on 11/20/24.
//

import UIKit

import UIKit

class ArticleDetailViewController: UIViewController
{
    var article: [String: Any]?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Set article details using @IBOutlet-connected UI elements
        if let article = article
        {
            titleLabel.text = article["title"] as? String
            contentTextView.text = article["content"] as? String
        }
    }
}

