//
//  MembersTableViewController.swift
//  DALIApp
//
//  Created by Sofia Stanescu-Bellu on 2/10/17.
//  Copyright © 2017 sofiastb. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class MembersTableViewController: UITableViewController {
    
    // MARK: Properties
    var members: [Member] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Reference to Firebase Database
        let ref = FIRDatabase.database().reference().child("members")
        
        // Snapshot of the FireBase Data
        ref.observe(.value, with: { snapshot in
            // Had an issue where the snaphsot didn't exist so I added this if statement
            if snapshot.exists() {
                // Populates Members Array
                for member in snapshot.children {
                    let newMember = Member(snapshot: member as! FIRDataSnapshot)
                    self.members.append(newMember)
                }
                self.tableView.reloadData()
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return members.count
    }

    // My row heights weren't being set properly so I hard coded them in.
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0;//Choose your custom row height
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Sets the 
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MemberTableViewCell else {
            fatalError("The dequeued cell is not of type MemberTableViewCell")
        }
        
        // Gets icon url and name from the members database
        let member = members[indexPath.row]
        let url = URL(string: member.iconUrl)
        
        // Implemented Task to guarantee that the icon urls wouldn't be nil.
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                cell.icon.image = UIImage(data: data)
            } 
        }
        
        task.resume()
        
        cell.nameLabel.text = member.name
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
