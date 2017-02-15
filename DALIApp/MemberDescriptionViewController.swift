//
//  MemberDescriptionViewController.swift
//  DALIApp
//
//  Created by Sofia Stanescu-Bellu on 2/10/17.
//  Copyright © 2017 sofiastb. All rights reserved.
//

import UIKit
import SafariServices

class MemberDescriptionViewController: UIViewController {
    
    // Outlets for the different parts of the view controller
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var projects: UILabel!
    @IBOutlet weak var urlButton: UIButton!
    @IBOutlet weak var location: UIButton!
    
    // Variable for the Member object passed from the table view
    var chosenMember: Member? {
        didSet {
            // Updates the view.
            configureView()
        }
    }
    
    // The function that updates the view.
    func configureView() {
        // Update the user interface for the detail item.
        if let chosenMember = self.chosenMember {
            if let icon = icon, let name = name, let message = message, let projects = projects {
                // Turns url string into useable link
                let url = URL(string: chosenMember.iconUrl)
            
                // Implemented Task to guarantee that the icon urls wouldn't be nil.
                let task = URLSession.shared.dataTask(with: url!) { data, response, error in
                    guard let data = data, error == nil else { return }
                    DispatchQueue.main.async() {
                        icon.image = UIImage(data: data)
                    }
                }
            
                task.resume()
            
                // Sets the various aspects of the DetailViewController
                name.text = "Hi! I'm " + (chosenMember.name) + "."
                message.text = chosenMember.message
                projects.text = (chosenMember.project).joined(separator: ", ")
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Makes buttons' corners round
        urlButton.layer.cornerRadius = 10
        location.layer.cornerRadius = 10
        
        // Loads thew view.
        configureView()
        
    }
    
    // Makes profile images round
    override func viewDidLayoutSubviews() {
        icon.layer.cornerRadius = icon.frame.size.width/2
        icon.clipsToBounds = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func loadWebsite(_ sender: Any) {
        
        // Turns the website string into a URL
        let website = URL(string: (chosenMember?.url)!)
        
        // Instantiates a SafariViewController to display the website.
        let safariViewController = SFSafariViewController(url: website!)
        self.present(safariViewController, animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
