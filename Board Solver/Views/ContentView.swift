//
//  ContentView.swift
//  Board Solver
//
//  Created by Henry Robbins on 6/4/24.
//

import SwiftUI

struct ContentView: View 
{
    @State private var viewModel = ViewModel()
    
    var body: some View
    {
        VStack 
        {
            CameraView(image: $viewModel.currentFrame)
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            HStack{
                Button {
                    print("scanning")
                } label: {
                    Label("", image: "scan_prompt")
                }
                .frame(maxWidth: .infinity)
                Button {
                    print("locking")
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
