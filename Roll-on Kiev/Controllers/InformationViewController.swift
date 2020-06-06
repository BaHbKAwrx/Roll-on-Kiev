//
//  InformationViewController.swift
//  Roll-on Kiev
//
//  Created by Shmygovskii Ivan on 7/8/19.
//  Copyright © 2019 Shmygovskii Ivan. All rights reserved.
//

import UIKit
import GoogleMaps

final class InformationViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet private weak var mapView: GMSMapView!
    @IBOutlet private weak var addressLabel: UILabel!
    
    private let eventAddress = "Бориспільське шосе, 18 км, Київ"
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addressLabel.text = eventAddress
        
        // Create a GMSCameraPosition that tells the map to display the coordinate
        let camera = GMSCameraPosition.camera(withLatitude: 50.401723, longitude: 30.694389, zoom: 13.0)
        mapView.camera = camera

        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 50.401723, longitude: 30.694389)
        marker.title = "Roll-on"
        marker.snippet = "Бориспільське шосе, 18 км, Київ"
        marker.map = mapView
    }
}
