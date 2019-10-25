//
//  TemplateCreator.swift
//  CarplayNavigation
//
//  Created by Gispert, Othmar on 10/24/19.
//  Copyright © 2019 Gispert, Othmar. All rights reserved.
//

import UIKit
import CarPlay

enum BarButtonType: String {
    case showList = "Show List"
    case panning = "Pan Map"
    case dismiss = "Dismiss"
}

protocol TemplateCreatorDelegate: class {
    func showResultsList()
}

class TemplateCreator: NSObject {

    static let shared = TemplateCreator()
    
    weak var delegate: TemplateCreatorDelegate?
    
    var mapTemplate: CPMapTemplate?
    var listOfItems = [CPListItem]()
    var listSections = [CPListSection]()
    
    func createRootTemplate() -> CPMapTemplate {
        let mapTemplate = CPMapTemplate()
        
        let searchBarButton = createBarButton(.showList)
        mapTemplate.leadingNavigationBarButtons = [searchBarButton]
        
        let panningBarButton = createBarButton(.panning)
        mapTemplate.trailingNavigationBarButtons = [panningBarButton]
        
        mapTemplate.automaticallyHidesNavigationBar = false
        
        return mapTemplate
    }
    
    func createListTemplate() -> CPListTemplate {
        if let results = ResultsManager.shared.results {
            let images = ResultsManager.shared.images
            
            for result in results {
                if let image = images.map({$0.first}).filter({$0?.key == result.id}).first {
                    let item = CPListItem(text: result.name, detailText: result.description, image: image?.value, showsDisclosureIndicator: false)
                    listOfItems.append(item)
                }
            }
        }
        
        let sections = CPListSection(items: listOfItems, header: "Restaurants", sectionIndexTitle: "Near Restaurants")
        
        listSections.append(sections)
        
        return CPListTemplate(title: "Restaurants", sections: listSections)
    }
    
    func createBarButton(_ type: BarButtonType) -> CPBarButton {
        let barButton = CPBarButton(type: .text) { (button) in            
            switch(type) {
            case .dismiss:
                self.mapTemplate?.dismissPanningInterface(animated: true)
            case .panning:
                self.mapTemplate?.showPanningInterface(animated: true)
                self.mapTemplate?.trailingNavigationBarButtons = [self.createBarButton(.dismiss)]
            case .showList:
                self.delegate?.showResultsList()
            }
        }
        barButton.title = type.rawValue
        return barButton
    }
}
