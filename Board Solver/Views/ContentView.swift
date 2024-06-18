//
//  ContentView.swift
//  Board Solver
//
//  Created by Henry Robbins on 6/4/24.
//

import SwiftUI
import CoreML
import Vision

struct ContentView: View
{
    @State private var viewModel = ViewModel()
    @ObservedObject var classifier: ImageClassifier

    var body: some View
    {
        ZStack
        {
            CameraView(image: $viewModel.currentFrame,  isLocked: $viewModel.isLocked)
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            HStack{
                Button 
                {
                    print("scanning")
                    if let image = $viewModel.currentFrame.wrappedValue
                    {
                        let uiImage = UIImage.init(cgImage: image)
                        classifier.detect(uiImage: uiImage)
                    }
                } label: {
                    Label("", image: "scan_prompt")
                }
                .frame(maxWidth: 175)
                Button {
                    print("locking")
                    viewModel.toggleLock()
                } label: {
                    Label("", image: "lock_prompt")
                }
                .frame(maxWidth: 175)
            }
            .padding()
        }
        .padding()
    }
}
