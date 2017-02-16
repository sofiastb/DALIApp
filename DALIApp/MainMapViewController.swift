//
//  MainMapViewController.swift
//  This view controller displays a map with all of the DALI Members' 
//  locations on it -- a pin at their latitude and longitude coordinates 
//  with their name on it.
//  DALIApp
//
//  Created by Sofia Stanescu-Bellu on 2/15/17.
//  Copyright © 2017 sofiastb. All rights reserved.
//

import UIKit
import GoogleMaps

class MainMapViewController: UIViewController {
    
    var membersMap: [Member] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Title for the navigation controller.
        self.title = "DALI Map"
    }
    
    override func loadView() {
        
        // Create a GMSCameraPosition that tells the map to display the member
        // coordinates at zoom level 1.
        let camera = GMSCameraPosition.camera(withLatitude: 0.0, longitude: 0.0, zoom: 2.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        for member in membersMap {
            // Creates a marker in the center of the map for each DALI member.
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(member.lat_long[0]), longitude: CLLocationDegrees(member.lat_long[1]))
            marker.title = member.name
            marker.snippet = (member.project).joined(separator: ", ")
            marker.map = mapView
        }
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
