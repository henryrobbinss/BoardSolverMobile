//
//  Classifier.swift
//  Board Solver
//
//  Created by Alex Mattoni on 6/18/24.
//

import CoreML
import Vision
import CoreImage
import UIKit

struct Classifier 
{
    
    static func createFImageClassifier() -> VNCoreMLModel
    {
        // Use a default model configuration.
        let defaultConfig = MLModelConfiguration()

        // Create an instance of the image classifier's wrapper class.
        let imageClassifierWrapper = try? Connect4_2_Iteration_310(configuration: defaultConfig)

        guard let imageClassifier = imageClassifierWrapper else {
            fatalError("App failed to create an image classifier model instance.")
        }

        // Get the underlying model instance.
        let imageClassifierModel = imageClassifier.model

        // Create a Vision instance using the image classifier's model instance.
        guard let imageClassifierVisionModel = try? VNCoreMLModel(for: imageClassifierModel) else {
            fatalError("App failed to create a `VNCoreMLModel` instance.")
        }

        return imageClassifierVisionModel
    }
    
    private static let f_imageClassifier = createFImageClassifier()
    
    private(set) var f_results: [VNRecognizedObjectObservation]?
    
    mutating func f_detect(ciImage: CIImage, playerColor: Int) -> [[Int]]
    {
        
        let request = VNCoreMLRequest(model: Classifier.f_imageClassifier.self)
        
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])

        try? handler.perform([request])
        
        guard let f_results = request.results as? [VNRecognizedObjectObservation] else
        {
            return [[0]]
        }
        
        return Board.convertBoard(results: f_results, width: CGFloat(ciImage.cgImage!.width), height: CGFloat(ciImage.cgImage!.height), playerColor: playerColor)
    }
    
    static func createSImageClassifier() -> VNCoreMLModel
    {
        // Use a default model configuration.
        let defaultConfig = MLModelConfiguration()

        // Create an instance of the image classifier's wrapper class.
        let imageClassifierWrapper = try? scrambleModel(configuration: defaultConfig)

        guard let imageClassifier = imageClassifierWrapper else {
            fatalError("App failed to create an image classifier model instance.")
        }

        // Get the underlying model instance.
        let imageClassifierModel = imageClassifier.model

        // Create a Vision instance using the image classifier's model instance.
        guard let imageClassifierVisionModel = try? VNCoreMLModel(for: imageClassifierModel) else {
            fatalError("App failed to create a `VNCoreMLModel` instance.")
        }

        return imageClassifierVisionModel
    }
    
    private static let s_imageClassifier = createSImageClassifier()
    
    private(set) var s_results: [VNRecognizedObjectObservation]?
    
    mutating func s_detect(ciImage: CIImage) -> [[Character]]
    {
        
        let s_request = VNCoreMLRequest(model: Classifier.s_imageClassifier.self)
        
        let s_handler = VNImageRequestHandler(ciImage: ciImage, options: [:])

        try? s_handler.perform([s_request])
        
        guard let s_results = s_request.results as? [VNRecognizedObjectObservation] else
        {
            return [[Character("*")]]
        }
        
        return Board.convertSBoard(results: s_results, width: CGFloat(ciImage.cgImage!.width), height: CGFloat(ciImage.cgImage!.height))
    }
}
