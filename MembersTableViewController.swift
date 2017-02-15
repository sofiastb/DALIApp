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
import FontAwesome_swift

class MembersTableViewController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var mapButton: UIBarButtonItem!
    
    // MARK: Properties
    // An array of member objects that correspond to DALI's members
    var members: [Member] = []
    var filteredMembers: [Member] = []
    // A variable for the Description View Controller
    var memberDescriptionViewController: MemberDescriptionViewController? = nil
    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets the globe map button in the table view.
        let attributes = [NSFontAttributeName: UIFont.fontAwesome(ofSize: 25)] as [String: Any]
        mapButton.setTitleTextAttributes(attributes, for: .normal)
        mapButton.title = String.fontAwesomeIcon(name: .globe)
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        
        // Setup the Scope Bar
        searchController.searchBar.scopeButtonTitles = ["All", "Past", "Core", "Staff", "None"]
        tableView.tableHeaderView = searchController.searchBar
        
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
        
        // Delegates for the empty table view.
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        
        // Sets up the split view controller
        if let splitViewController = splitViewController {
            let controllers = splitViewController.viewControllers
            memberDescriptionViewController = (controllers[controllers.count - 1] as! UINavigationController).topViewController as? MemberDescriptionViewController
        }
    }
    
    // Function to control the appearance of the split view controller.
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredMembers.count
        }
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
        // Sets the cell that is accessed
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MemberTableViewCell else {
            fatalError("The dequeued cell is not of type MemberTableViewCell")
        }
        
        // Determines which array to look in.
        let member: Member?
        if searchController.isActive && searchController.searchBar.text != "" {
            member = filteredMembers[indexPath.row]
        } else {
            member = members[indexPath.row]
        }
        
        let url = URL(string: (member?.iconUrl)!)
        
        // Implemented Task to guarantee that the icon urls wouldn't be nil.
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                cell.icon.image = UIImage(data: data)
            }
        }
        
        task.resume()
        
        cell.nameLabel.text = member?.name
        
        return cell
    }
    
    // Filters content based on scope.
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredMembers = members.filter({( member : Member) -> Bool in
            let categoryMatch = (scope == "All")
            return categoryMatch && member.name.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    // Defines the scopes for the search.
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        let searchProject: String
        
        if selectedScope == 0 {
            filteredMembers = members
        } else if selectedScope == 1 {
            searchProject = "None"
            filteredMembers = members.filter { $0.project.contains(searchProject) }
        } else if selectedScope == 2 {
            searchProject = "Core"
            filteredMembers = members.filter { $0.project.contains(searchProject) }
        } else if selectedScope == 3 {
            searchProject = "Staff"
            filteredMembers = members.filter { $0.project.contains(searchProject) }
        } else {
            searchProject = "Project"
            filteredMembers = members.filter { $0.project.contains("Staff") == false && $0.project.contains("Staff") == false && $0.project.contains("None") == false}
        }
        
        tableView.reloadData()
    }
    
    // Filters the results of the query
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }

    
    // MARK: Empty table view
    // Title for the empty table view.
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Loading..."
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    // If I want a description for the empty table view.
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "The list of DALI Members will load shortly!"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    // If I want an image for the empty table view.
//    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
//        return UIImage(named: "dali.jpg")
//    }
    
    // If I want a button for the empty table view.
//    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControlState) -> NSAttributedString? {
//        let str = "Add Grokkleglob"
//        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.callout)]
//        return NSAttributedString(string: str, attributes: attrs)
//    }
    
    // If I want a button message for the empty table view.
    
//    func emptyDataSet(_ scrollView: UIScrollView, didTap button: UIButton) {
//        let ac = UIAlertController(title: "Button tapped!", message: nil, preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "Hurray", style: .default))
//        present(ac, animated: true)
//    }
    

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

    
    // MARK: - Navigation
    // Takes the member item and moves it via the segue to the MemberDescriptionViewController. 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MemberDetails" {
            if let indexPath = tableView.indexPathForSelectedRow {
                print(tableView.indexPathForSelectedRow!)
                let member = members[indexPath.row]
                print(members[indexPath.row])
                let controller = (segue.destination as! UINavigationController).topViewController as! MemberDescriptionViewController
                controller.chosenMember = Member(name: member.name, message: member.message, iconUrl: member.iconUrl, url: member.url, lat_long: member.lat_long, project: member.project)
                
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
}

