//
//  MapViewController.swift
//  CarplayNavigation
//
//  Created by Gispert, Othmar on 10/24/19.
//  Copyright © 2019 Gispert, Othmar. All rights reserved.
//

import Foundation
import UIKit
import CarPlay
import GoogleMaps

class MapViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        let camera = GMSCameraPosition.camera(withLatitude: 32.779014, longitude: -96.799628, zoom: 10)
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        displayLocationMarker(mapView)
        self.view = mapView
    }
    
    func displayLocationMarker(_ mapView: GMSMapView) {
        guard let results = ResultsManager.shared.results else { return }
        
        for place in results {
            let position = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
            let marker = GMSMarker(position: position)
            marker.title = place.name
            marker.map = mapView
        }
    }
    
}
