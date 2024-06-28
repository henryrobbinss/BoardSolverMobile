//
//  ImageClassifier.swift
//  Board Solver
//
//  Created by Alex Mattoni on 6/18/24.
//

import SwiftUI

class ImageClassifier: ObservableObject 
{
    
    @Published private var classifier = Classifier()
        
    func detect(uiImage: UIImage) -> UIImage
    {
        guard let ciImage = CIImage (image: uiImage) else { return uiImage}
        return classifier.detect(ciImage: ciImage)
    }
        
}
