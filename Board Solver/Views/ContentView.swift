//
//  ContentView.swift
//  Board Solver
//
//  Created by Henry Robbins on 6/4/24.
//

import SwiftUI
import CoreML
import Vision
import RealityKit
import ARKit

struct ContentView: View
{
    @ObservedObject var classifier: ImageClassifier
    @State private var arView = ARView(frame: .zero)
    @State private var capturedImage: UIImage?

    var body: some View
    {
        ZStack
        {
            ARViewContainer(arView: $arView)
                .edgesIgnoringSafeArea(.all)
            VStack{
                Spacer()
                
                BoardView()
                    .padding(.bottom, 20)
                
                HStack{
                    Button
                    {
                        print("scanning")
                        captureFrame()
                        if let image = capturedImage {
                            classifier.detect(uiImage: image)
                        }
                    } label: {
                        Label("", image: "scan_prompt")
                    }
                    .frame(maxWidth: 175)
                    Button {
                        print("locking")
                    } label: {
                        Label("", image: "lock_prompt")
                    }
                    .frame(maxWidth: 175)
                }
                .padding()
            }
            .padding(.bottom, 50)
        }
        .ignoresSafeArea(.all)
    }
    
    private func captureFrame() {
        let frame = arView.session.currentFrame
        let ciImage = CIImage(cvPixelBuffer: frame!.capturedImage)
        let context = CIContext()
        if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
            capturedImage = UIImage(cgImage: cgImage)
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    @Binding var arView: ARView
    
    func makeUIView(context: Context) -> ARView {
        arView = ARView(frame: .zero)
        let config = ARWorldTrackingConfiguration()
        arView.session.run(config)
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
}

#Preview {
    BoardView()
}
