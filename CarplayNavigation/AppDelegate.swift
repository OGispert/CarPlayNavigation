//
//  AppDelegate.swift
//  CarplayNavigation
//
//  Created by Gispert, Othmar on 10/24/19.
//  Copyright © 2019 Gispert, Othmar. All rights reserved.
//

import UIKit
import CarPlay
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var carWindow: CPWindow?
    var interfaceController: CPInterfaceController?
    var mapTemplate: CPMapTemplate?
    var listTemplate: CPListTemplate?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey("YOUR_GOOGLE_KEY")
        GMSPlacesClient.provideAPIKey("YOUR_GOOGLE_KEY")
        return true
    }
}



// MARK - Extensions

extension AppDelegate: CPApplicationDelegate, CPMapTemplateDelegate {
    func application(_ application: UIApplication, didConnectCarInterfaceController interfaceController: CPInterfaceController, to window: CPWindow) {
        
        self.interfaceController = interfaceController
        carWindow = window
        TemplateCreator.shared.delegate = self
        
        mapTemplate = TemplateCreator.shared.createRootTemplate()
        listTemplate = TemplateCreator.shared.createListTemplate()
        
        guard let map = mapTemplate else { return }
        map.mapDelegate = self
        
        TemplateCreator.shared.mapTemplate = mapTemplate
        
        interfaceController.setRootTemplate(map, animated: true)
        
        window.rootViewController = MapViewController()
    }
    
    func application(_ application: UIApplication, didDisconnectCarInterfaceController interfaceController: CPInterfaceController, from window: CPWindow) {
        print("CarPlay Disconnected")
    }
    
    func mapTemplateDidBeginPanGesture(_ mapTemplate: CPMapTemplate) {
        
    }
    
    func mapTemplateWillDismissPanningInterface(_ mapTemplate: CPMapTemplate) {
        mapTemplate.trailingNavigationBarButtons = [TemplateCreator.shared.createBarButton(.panning)]
    }
    
}

extension AppDelegate: TemplateCreatorDelegate {
    func showResultsList() {
        guard let list = listTemplate else { return }
        interfaceController?.pushTemplate(list, animated: true)
    }
    
}
