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
    @State var boardView: BoardView

    var body: some View
    {
        ZStack
        {
            ARViewContainer(arView: $arView)
                .edgesIgnoringSafeArea(.all)
            VStack{
                Spacer()
                
                boardView
                    .padding(.bottom, 20)
                
                HStack{
                    Button
                    {
                        print("scanning")
                        captureFrame()
                        if let image = capturedImage 
                        {
                            $boardView.wrappedValue.updateBoard(brd: classifier.detect(uiImage: rotateImage90DegreesClockwise(image: image)!))
                            
                        }
                    } label: {
                        Label("", image: "scan_prompt")
                    }
                    .frame(maxWidth: 175)
                   
                    Button
                    {
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

func rotateImage90DegreesClockwise(image: UIImage) -> UIImage? {
    guard let cgImage = image.cgImage else { return nil }
    
    // Calculate the size of the rotated image
    let rotatedSize = CGSize(width: image.size.height, height: image.size.width)
    
    // Create a new bitmap context
    UIGraphicsBeginImageContextWithOptions(rotatedSize, false, image.scale)
    let context = UIGraphicsGetCurrentContext()
    
    // Move the origin to the middle of the image so we can rotate around the center.
    context?.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
    
    // Rotate the image context by 90 degrees clockwise
    context?.rotate(by: CGFloat.pi / 2)
    
    // Draw the image into the context
    context?.scaleBy(x: 1.0, y: -1.0)
    context?.draw(cgImage, in: CGRect(x: -image.size.width / 2, y: -image.size.height / 2, width: image.size.width, height: image.size.height))
    
    // Get the rotated image from the context
    let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
    
    // Clean up the context
    UIGraphicsEndImageContext()
    
    return rotatedImage
}

#Preview {
    BoardView(board: Array(repeating: Array(repeating: 2, count: 7), count: 6))
}
