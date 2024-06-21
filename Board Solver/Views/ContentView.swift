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

struct ContentView: View
{
    @State private var viewModel = ViewModel()
    @ObservedObject var classifier: ImageClassifier

    var body: some View
    {
        ZStack
        {
            ARViewContainer().edgesIgnoringSafeArea(.all)
            VStack{
                Spacer()
                
                BoardView()
                    .padding(.bottom, 20)
                
                
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
            .padding(.bottom, 50)
        }
        .ignoresSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)

        // Create a cube model
        let mesh = MeshResource.generateBox(size: 0.1, cornerRadius: 0.005)
        let material = SimpleMaterial(color: .gray, roughness: 0.15, isMetallic: true)
        let model = ModelEntity(mesh: mesh, materials: [material])
        model.transform.translation.y = 0.05

        // Create horizontal plane anchor for the content
        let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.2, 0.2)))
        anchor.children.append(model)

        // Add the horizontal plane anchor to the scene
        arView.scene.anchors.append(anchor)

        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

#Preview {
    BoardView()
}
