//
//  ResultsModel.swift
//  CarplayNavigation
//
//  Created by Gispert, Othmar on 10/24/19.
//  Copyright © 2019 Gispert, Othmar. All rights reserved.
//

import UIKit

struct ResultsModel: Codable {
    let id: String
    let name: String
    let description: String?
    let imageUrl: String
    let latitude: Double
    let longitude: Double
}
