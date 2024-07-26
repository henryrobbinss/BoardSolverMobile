//
//  WordScrambleView.swift
//  Board Solver
//
//  Created by Alex Mattoni on 7/26/24.
//

import SwiftUI
import Vision
import RealityKit

struct WordScrambleView: View
{
    @State var arView = ARView()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View
    {
        ZStack
        {
            ARViewContainer(arView: $arView)
                .edgesIgnoringSafeArea(.all)
            
            VStack
            {
                HStack 
                {
                    Button
                    {
                        dismiss()
                    } label: {
                        Label("", image: "Back_prompt")
                    }
                    .padding()
                    
                    Spacer()
                }
            }
        }
    }
}
