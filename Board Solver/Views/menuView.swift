//
//  menuView.swift
//  Board Solver
//
//  Created by Henry Robbins on 6/14/24.
//

import SwiftUI

struct menuView: View {
    var body: some View {
        ZStack{
            Rectangle()
                .background(Color.white)
            VStack{
                Image("prompt1").resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                HStack{
                    Image("red_prompt")
                    Image("yellow_prompt")
                }
            }
        }
    }
}

#Preview {
    menuView()
}
