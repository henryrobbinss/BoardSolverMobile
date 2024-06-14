//
//  viewController.swift
//  Board Solver
//
//  Created by Henry Robbins on 6/14/24.
//

import Foundation
import UIKit
import CoreML
import Vision

class viewController: UIViewController {
    var model: connect4?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the Core ML model
        do {
            model = try connect4(configuration: MLModelConfiguration())
        } catch {
            print("Failed to load Core ML model: \(error)")
        }
    }

    func predict(image: UIImage) {
        guard let resizedImage = image.resized(to: CGSize(width: 640, height: 640)),
              let pixelBuffer = resizedImage.pixelBuffer() else {
            print("Failed to convert UIImage to CVPixelBuffer")
            return
        }
        
        guard let model = model else {
            print("Model is not loaded")
            return
        }
        
        // Create a Core ML request
        let request = VNCoreMLRequest(model: try! VNCoreMLModel(for: model.model)) { request, error in
            if let results = request.results as? [VNRecognizedObjectObservation] {
                for result in results {
                    print("Detected object with confidence: \(result.confidence)")
                    // Process the result
                }
            } else if let error = error {
                print("Failed to process request: \(error)")
            }
        }
        
        // Create a Core ML request handler
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        do {
            try handler.perform([request])
        } catch {
            print("Failed to perform request: \(error)")
        }
    }
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }

    func pixelBuffer() -> CVPixelBuffer? {
        let width = Int(self.size.width)
        let height = Int(self.size.height)
        
        var pixelBuffer: CVPixelBuffer?
        let attributes: [NSObject: AnyObject] = [
            kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
            kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue
        ]
        
        let status = CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32ARGB, attributes as CFDictionary, &pixelBuffer)
        
        guard status == kCVReturnSuccess, let buffer = pixelBuffer else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(buffer, [])
        let pixelData = CVPixelBufferGetBaseAddress(buffer)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(buffer), space: colorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        
        context?.translateBy(x: 0, y: CGFloat(height))
        context?.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context!)
        self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        UIGraphicsPopContext()
        
        CVPixelBufferUnlockBaseAddress(buffer, [])
        
        return buffer
    }
}
