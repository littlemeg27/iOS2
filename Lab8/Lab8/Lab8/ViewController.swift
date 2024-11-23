//
//  ViewController.swift
//  Lab8
//
//  Created by Brenna Pavlinchak on 11/20/24.
//

import UIKit

class ViewController: UIViewController
{
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! // Connected via storyboard
    @IBOutlet weak var retryButton: UIButton! // Connected via storyboard
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        activityIndicator.center = view.center // Setting up the center
        activityIndicator.startAnimating() // Start animation on load
        
        fetchSources
        {
            [weak self] sources in
            DispatchQueue.main.async
            {
                self?.activityIndicator.stopAnimating() // Stop when done
                if let sources = sources
                {
                    let sourcesVC = SourceViewController() // Present the next screen
                    sourcesVC.sources = sources
                    self?.present(sourcesVC, animated: true)
                }
                else
                {
                    self?.showError() // Handle error
                }
            }
        }
    }
    
    @IBAction func retryLoading(_ sender: UIButton)
    {
        activityIndicator.startAnimating() // Start animation when retrying
        fetchSources
        {
            [weak self] sources in
            DispatchQueue.main.async
            {
                self?.activityIndicator.stopAnimating() // Stop on finish
                if let sources = sources
                {
                    let sourcesVC = SourceViewController()
                    sourcesVC.sources = sources
                    let navController = UINavigationController(rootViewController: sourcesVC)
                    navController.modalPresentationStyle = .fullScreen
                    self?.present(navController, animated: true)
                }
                else
                {
                    self?.showError() // Error handling
                }
            }
        }
    }
    
    func showError()
    {
        let alert = UIAlertController(title: "Error", message: "Failed to load sources. Please try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
