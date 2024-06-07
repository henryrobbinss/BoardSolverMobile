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
            Text("Board Solver App")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
