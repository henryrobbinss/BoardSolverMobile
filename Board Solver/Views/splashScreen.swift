//
//  splashScreen.swift
//  Board Solver
//
//  Created by Henry Robbins on 6/14/24.
//

import SwiftUI

struct splashScreen: View
{
    @State var isActive = false
    
    var body: some View
    {
            ZStack
            {
                if self.isActive
                {
                    MenuView()
                }
                else 
                {
                    Rectangle()
                        .background(Color.white)
                    Image("image1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                }
            }
            .onAppear
            {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
}

#Preview {
    splashScreen()
}
