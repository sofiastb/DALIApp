//
//  MemberDescriptionViewController.swift
//  DALIApp
//
//  Created by Sofia Stanescu-Bellu on 2/10/17.
//  Copyright © 2017 sofiastb. All rights reserved.
//

import UIKit

class MemberDescriptionViewController: UIViewController {
    
    // Outlets for the different parts of the view controller
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var projects: UILabel!
    
    
    // Variables for the data passed from the table view
    var iconImage: UIImage!
    var nameString: String!
    var messageString: String!
    var projectsArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
