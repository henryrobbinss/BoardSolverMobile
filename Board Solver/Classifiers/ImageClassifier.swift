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
        
    func f_detect(uiImage: UIImage, playerColor: Int) -> [[Int]]
    {
        guard let ciImage = CIImage (image: uiImage) else { return [[0]]}
        return classifier.f_detect(ciImage: ciImage, playerColor: playerColor)
    }
    
    func s_detect(uiImage: UIImage) -> [[Character]]
    {
        guard let ciImage = CIImage (image: uiImage) else { return [[Character("*")]]}
        return classifier.s_detect(ciImage: ciImage)
    }
        
}
