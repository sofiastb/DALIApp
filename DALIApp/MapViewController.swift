//
//  MapViewController.swift
//  This code sets up a view controller connected to each Members' detail
//  view controller. This view controller features a map with the individual
//  member's location displayed by a pin with their name.
//  DALIApp
//
//  Created by Sofia Stanescu-Bellu on 2/15/17.
//  Copyright © 2017 sofiastb. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    
    var memberMap: Member!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = memberMap.name + "'s Location"
    }
    
    override func loadView() {
        
        // Create a GMSCameraPosition that tells the map to display the member
        // coordinates at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: CLLocationDegrees(memberMap.lat_long[0]), longitude: CLLocationDegrees(memberMap.lat_long[1]), zoom: 10.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(memberMap.lat_long[0]), longitude: CLLocationDegrees(memberMap.lat_long[1]))
        marker.title = memberMap.name
        marker.snippet = (memberMap.project).joined(separator: ", ")
        marker.map = mapView
        
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
