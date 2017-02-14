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
    var chosenMember: Member?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Makes buttons' corners round
        urlButton.layer.cornerRadius = 10
        location.layer.cornerRadius = 10
        
        // Turns url string into useable link
        let url = URL(string: (chosenMember?.iconUrl)!)
        
        // Implemented Task to guarantee that the icon urls wouldn't be nil.
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                self.icon.image = UIImage(data: data)
            }
        }
        
        task.resume()
        
        // Sets the various aspects of the DetailViewController
        self.name.text = "Hi! I'm " + (self.chosenMember?.name)! + "."
        self.message.text = self.chosenMember?.message
        self.projects.text = (self.chosenMember?.project)!.joined(separator: ", ")
        
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
