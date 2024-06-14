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
    
    let model = try? connect4(configuration: MLModelConfiguration())
    
    var body: some View
    {
        VStack 
        {
            CameraView(image: $viewModel.currentFrame, isLocked: $viewModel.isLocked)
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            let image = UIImage(named: "input_image")
            predict(image: image)
            
            HStack{
                Button {
                    print("scanning")
                } label: {
                    Label("", image: "scan_prompt")
                }
                .frame(maxWidth: .infinity)
                Button {
                    print("locking")
                    viewModel.toggleLock()
                } label: {
                    Label("", image: "lock_prompt")
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
