//
//  ResultsManager.swift
//  CarplayNavigation
//
//  Created by Gispert, Othmar on 10/24/19.
//  Copyright © 2019 Gispert, Othmar. All rights reserved.
//

import UIKit

enum ImageServiceError: Error {
    case badUrl
    case noImage
    case server(Error)
}

class ResultsManager {
    static let shared = ResultsManager()
    
    private let baseURL = "http://dallas-restaurants.33gfuuywva.us-east-2.elasticbeanstalk.com"
    var results: [ResultsModel]?
    var images = [[String:UIImage]]()
    
    typealias ImageResult = Result<UIImage, ImageServiceError>
    typealias ImageCompletion = (ImageResult) -> Void
    

    func fetchSearchResults() {
        guard let url = URL(string: baseURL + "/restaurants") else { return }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { (results, response, error) in
            
            guard let dataResponse = results, error == nil else { return }
            
            do {
                let resultsModel = try JSONDecoder().decode([ResultsModel].self, from: dataResponse)
                self.results = resultsModel
                self.getImagesfromResults()
            } catch let parsingError {
                print("Error \(parsingError.localizedDescription)")
            }
        }.resume()
    }
    
    func getImagesfromResults() {
        guard let results = results else { return }
        for result in results {
            self.fetchImage(for: result.imageUrl) { resultImage in
                switch resultImage {
                case .success(let image):
                    self.images.append([result.id:image])
                    
                case .failure(let error):
                    print("Error loading image: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func fetchImage(for urlString: String, completion: @escaping ImageCompletion) {
        DispatchQueue.global().async {
            self.imageFromNetwork(for: urlString, completion: completion)
        }
    }
    
    private func imageFromNetwork(for urlString: String, completion: @escaping ImageCompletion) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.badUrl))
            return
        }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(.server(error)))
                return
            }
            
            guard let imageData = data,
                let image = UIImage(data: imageData) else {
                    completion(.failure(.noImage))
                    return
            }
            
            completion(.success(image))
            }.resume()
    }
}
