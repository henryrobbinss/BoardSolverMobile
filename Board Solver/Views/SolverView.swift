import SwiftUI
import CoreML
import Vision
import RealityKit
import ARKit
import UIKit

struct SolverView: View {
    // Existing properties remain unchanged
    @ObservedObject var FClassifier: ImageClassifier
    @Environment(\.dismiss) private var dismiss
    @State private var arView = ARView(frame: .zero)
    @State private var capturedImage: UIImage?
    @State var FBoardView: BoardView
    @State var playerColor: Int
    @Binding var FBoard: [[Int]]
    @Binding var SBoard: [[Character]]
    @State var FResultsBoard: [[Int]]
    @State private var isScanning = false
    @State private var isSolving = false
    @State var canSolve: Bool = false
    @Binding var game: String
    @Binding var letters: String
    @State private var alreadyWon = false

    var body: some View {
        GeometryReader { geometry in
            // Base sizes as per iPhone 13 Pro Max
            let baseWidth: CGFloat = 428
            let baseHeight: CGFloat = 926
            
            // Calculate scaling factors
            let widthScalingFactor = geometry.size.width / baseWidth
            let heightScalingFactor = geometry.size.height / baseHeight
            let scalingFactor = min(widthScalingFactor, heightScalingFactor)
            
            ZStack {
                ARViewContainer(arView: $arView)
                    .edgesIgnoringSafeArea(.all)
                
                if game == "scramble" {
                    ScrambleBoardView(board: $SBoard)
                }
                
                VStack {
                    Spacer()
                    
                    if game == "four" {
                        FBoardView
                            .padding(.bottom, 20 * scalingFactor)
                    }
                    
                    HStack(spacing: 20 * scalingFactor) {
                        // Scan Button
                        Button {
                            // Existing scan logic
                            if game == "four" {
                                DispatchQueue.global().async {
                                    isScanning = true
                                    withAnimation() {
                                        canSolve = true
                                        captureFrame()
                                        if let image = capturedImage {
                                            FResultsBoard = FClassifier.detect(uiImage: rotateImage90DegreesClockwise(image: image)!, playerColor: playerColor)
                                            $FBoardView.wrappedValue.updateBoard(brd: FResultsBoard)
                                            FBoardView.board = FResultsBoard
                                        }
                                    }
                                    isScanning = false
                                }
                            } else if game == "scramble" {
                                // Existing scramble logic
                                DispatchQueue.global().async {
                                    isScanning = true
                                    withAnimation() {
                                        canSolve = true
                                        captureFrame()
                                        if let image = capturedImage {
                                            print(image)
                                        }
                                    }
                                    isScanning = false
                                }
                                SBoard[7][7] = "F"
                                SBoard[7][8] = "O"
                                SBoard[7][9] = "C"
                                SBoard[7][10] = "U"
                                SBoard[7][11] = "S"
                                // Add extra padding only for scramble game

                            }
                        } label: {
                            Rectangle()
                                .fill(.orange)
                                .frame(width: 180 * scalingFactor, height: 75 * scalingFactor)
                                .cornerRadius(15 * scalingFactor)
                                .overlay(Group {
                                    Text("SCAN")
                                        .font(.custom("PatrickHandSC-Regular", size: 50 * scalingFactor))
                                        .foregroundStyle(.black)
                                    RoundedRectangle(cornerRadius: 15 * scalingFactor)
                                        .stroke(Color.black, lineWidth: 5 * scalingFactor)
                                })
                        }
                        .frame(maxWidth: 180 * scalingFactor)
                        
                        // Solve Button
                        Button {
                            // Existing solve logic
                            if game == "four" {
                                DispatchQueue.global().async {
                                    isSolving = true
                                    withAnimation() {
                                        FResultsBoard = Board.startSolving(board: FBoard, playerColor: playerColor)
                                        if(FResultsBoard == FBoardView.board) {
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
                                .frame(width: 180 * scalingFactor, height: 75 * scalingFactor)
                                .cornerRadius(15 * scalingFactor)
                                .overlay(Group {
                                    Text("SOLVE")
                                        .font(.custom("PatrickHandSC-Regular", size: 50 * scalingFactor))
                                        .foregroundStyle(.black)
                                    RoundedRectangle(cornerRadius: 15 * scalingFactor)
                                        .stroke(Color.black, lineWidth: 5 * scalingFactor)
                                })
                        }
                        .frame(maxWidth: 180 * scalingFactor)
                        .disabled(!canSolve)
                    }
                    .padding(10 * scalingFactor)
                    .alert("Solving Error", isPresented: $alreadyWon) {
                        Button("OK", role: .cancel) {
                            alreadyWon = false
                        }
                    } message: {
                        Text("This Board is Already Solved!")
                    }
                    
                    // Back Button
                    Button {
                        dismiss()
                    } label: {
                        Rectangle()
                            .fill(.gray)
                            .frame(width: 100 * scalingFactor, height: 60 * scalingFactor)
                            .cornerRadius(15 * scalingFactor)
                            .overlay(Group {
                                Text("BACK")
                                    .font(.custom("PatrickHandSC-Regular", size: 30 * scalingFactor))
                                    .foregroundStyle(.white)
                                RoundedRectangle(cornerRadius: 15 * scalingFactor)
                                    .stroke(Color.black, lineWidth: 5 * scalingFactor)
                            })
                    }
                    .frame(minWidth: 200 * scalingFactor)
                }
                .padding(.bottom,  geometry.size.height < 830 && game == "scramble" ? 0 :50 * scalingFactor)

                // Progress Views
                ProgressView("Scanning")
                    .progressViewStyle(CircularProgressViewStyle())
                    .background(.white)
                    .foregroundColor(.black)
                    .opacity(isScanning ? 0.9 : 0)
                    .frame(width: 150 * scalingFactor, height: 150 * scalingFactor)
                
                ProgressView("Solving")
                    .progressViewStyle(CircularProgressViewStyle())
                    .background(.white)
                    .foregroundColor(.black)
                    .opacity(isSolving ? 0.9 : 0)
                    .frame(width: 150 * scalingFactor, height: 150 * scalingFactor)
            }
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

// ARViewContainer struct
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

// Image rotation helper function
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
