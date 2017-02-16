//
//  Member.swift
//  Defines the Member object. Each DALI Member has a name, message, url to their
//  icon picture, array with latitude and longitude coordinates, and an array 
//  with names of the projects they're involved in. All of the Member data is 
//  stored in a Firebase database. 
//  DALIApp
//
//  Created by Sofia Stanescu-Bellu on 2/10/17.
//  Copyright © 2017 sofiastb. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Member {
    
    // Properties of the Member object
    var name: String
    var message: String
    var iconUrl: String
    var url: String
    var lat_long: [Int]
    var project: [String]
    var ref: FIRDatabaseReference?
    
    // Initializes the Member object
    init(name: String, message: String, iconUrl: String, url: String, lat_long: [Int], project: [String]) {
        self.name = name
        self.message = message
        self.iconUrl = iconUrl
        self.url = url
        self.lat_long = lat_long
        self.project = project
        self.ref = nil
    }
    
    // Initializes the Member snapshot
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: Any]
        name = snapshotValue["name"] as! String
        message = snapshotValue["message"] as! String
        iconUrl = snapshotValue["iconUrl"] as! String
        url = snapshotValue["url"] as! String
        lat_long = snapshotValue["lat_long"] as! [Int]
        if snapshotValue["project"] == nil {
            project = ["None"]
        } else {
            project = snapshotValue["project"] as! [String]
        }
        ref = snapshot.ref
    }
    
    // Makes the data retrievable
    func toAnyObject() -> Any {
        return [
            "name": name,
            "message": message,
            "iconUrl": iconUrl,
            "url": url,
            "lat_long": lat_long,
            "project": project
        ]
    }
    
    
}
