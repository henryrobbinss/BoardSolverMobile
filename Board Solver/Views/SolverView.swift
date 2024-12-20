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
import UIKit

struct SolverView: View
{
    @ObservedObject var Classifier: ImageClassifier
    @Environment(\.dismiss) private var dismiss
    @State private var arView = ARView(frame: .zero)
    @State private var capturedImage: UIImage?
    @State var FBoardView: BoardView
    @State var playerColor: Int
    @Binding var FBoard: [[Int]]
    @Binding var SBoard: [[Character]]
    @State var FResultsBoard: [[Int]]
    @State var SResultsBoard: [[Character]]
    @State private var isScanning = false
    @State private var isSolving = false
    @State var canSolve: Bool = false
    @Binding var game: String
    @Binding var letters: String
    @State private var alreadyWon = false

    var body: some View
    {
        ZStack
        {
            ARViewContainer(arView: $arView)
                .edgesIgnoringSafeArea(.all)
            
            if game == "scramble" {
                ScrambleBoardView(board: $SBoard)
            }
            
            VStack
            {
                Spacer()
                
                if game == "four" {
                    FBoardView
                        .padding(.bottom, 20)
                } else if game == "scramble" {
                    // ScrambleBoardView()
                }
                
                
                HStack{
                    Button
                    {
                        if game == "four" {
                            DispatchQueue.global().async
                            {
                                isScanning = true
                                withAnimation(){
                                    canSolve = true
                                    captureFrame()
                                    if let image = capturedImage
                                    {
                                        FResultsBoard = Classifier.f_detect(uiImage: rotateImage90DegreesClockwise(image: image)!, playerColor: playerColor)
                                        $FBoardView.wrappedValue.updateBoard(brd: FResultsBoard)
                                        FBoardView.board = FResultsBoard
                                    }
                                }
                                isScanning = false
                            }
                        } else if game == "scramble" {
                            DispatchQueue.global().async
                            {
                                isScanning = true
                                withAnimation(){
                                    canSolve = true
                                    captureFrame()
                                    if let image = capturedImage
                                    {
                                        SResultsBoard = Classifier.s_detect(uiImage: rotateImage90DegreesClockwise(image: image)!)
                                        //$SBoardView.wrappedValue.updateBoard(brd: SResultsBoard)
                                        //FBoardView.board = FResultsBoard
                                        SBoard = SResultsBoard
                                    }
                                }
                                isScanning = false
                            }
//                            SBoard[7][7] = "F"
//                            SBoard[7][8] = "O"
//                            SBoard[7][9] = "C"
//                            SBoard[7][10] = "U"
//                            SBoard[7][11] = "S"
                            
                        }
                        
                    } label: {
                        Rectangle()
                            .fill(.orange)
                            .frame(width: 180, height: 75)
                            .cornerRadius(15)
                            .overlay(Group{
                                Text("SCAN")
                                    .font(.custom("PatrickHandSC-Regular", size: 50))
                                    .foregroundStyle(.black)
                                RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.black, lineWidth: 5)
                                })
                    }
                    .frame(maxWidth: 180)
                    
                   
                    Button
                    {
                        if game == "four" {
                            DispatchQueue.global().async
                            {
                                isSolving = true
                                withAnimation(){
                                    FResultsBoard = Board.startSolving(board: FBoard, playerColor: playerColor)
                                    if(FResultsBoard == FBoardView.board){
                                        alreadyWon = true
                                    } else {
                                        $FBoardView.wrappedValue.updateBoard(brd: FResultsBoard)
                                        FBoardView.board = FResultsBoard
                                    }
                                }
                                isSolving = false
                            }
                        } else if game == "scramble" {
                            print("solving for scramble")
                        }
                    } label: {
                        Rectangle()
                            .fill(.green)
                            .frame(width: 180, height: 75)
                            .cornerRadius(15)
                            .overlay(Group{
                                Text("SOLVE")
                                    .font(.custom("PatrickHandSC-Regular", size: 50))
                                    .foregroundStyle(.black)
                                RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.black, lineWidth: 5)
                                })
                    }
                    .frame(maxWidth: 180)
                    .disabled(!canSolve)
                }
                .padding()
                .alert("Solving Error", isPresented: $alreadyWon) {
                            Button("OK", role: .cancel) {
                                alreadyWon = false
                            }
                        } message: {
                            Text("This Board is Already Solved!")
                        }
                
                Button {
                    dismiss()
                } label: {
                    Rectangle()
                        .fill(.gray)
                        .frame(width: 100, height: 60)
                        .cornerRadius(15)
                        .overlay(Group{
                            Text("BACK")
                                .font(.custom("PatrickHandSC-Regular", size: 30))
                                .foregroundStyle(.white)
                            RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.black, lineWidth: 5)
                            })
                }
                .frame(minWidth: 200)
            }
            .padding(.bottom, 50)

            ProgressView("Scanning")
                .progressViewStyle(CircularProgressViewStyle())
                .background(.white)
                .foregroundColor(.black)
                .opacity(isScanning ? 0.9 : 0)
                .frame(width: 150, height: 150)
            
            ProgressView("Solving")
                .progressViewStyle(CircularProgressViewStyle())
                .background(.white)
                .foregroundColor(.black)
                .opacity(isSolving ? 0.9 : 0)
                .frame(width: 150, height: 150)

        }
        .ignoresSafeArea(.all)
    }
    
    private func captureFrame()
    {
        let frame = arView.session.currentFrame
        let ciImage = CIImage(cvPixelBuffer: frame!.capturedImage)
        let context = CIContext()
        if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
            capturedImage = UIImage(cgImage: cgImage)
        }
    }
}

struct ARViewContainer: UIViewRepresentable
{
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
