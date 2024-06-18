//
//  Classifier.swift
//  Board Solver
//
//  Created by Alex Mattoni on 6/18/24.
//

import CoreML
import Vision
import CoreImage

struct Classifier {
    
    private(set) var results: String?
    
    mutating func detect(ciImage: CIImage) {
        print("Trying to load model")
        guard let model = try? VNCoreMLModel(for: connect4(configuration: MLModelConfiguration()).model)
        else {
            return
        }
        
        print("Creating request")
        let request = VNCoreMLRequest(model: model)
        
        print("Creating handler")
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        
        print("Performing request")
        try? handler.perform([request])
        
        print("Getting results")
        guard let results = request.results as? [VNClassificationObservation] else
        {
            print("Error getting results")
            return
        }
        
        print("Results should be here by now")
        if let firstResult = results.first
        {
            self.results = firstResult.identifier
        }
        
    }
    
}


