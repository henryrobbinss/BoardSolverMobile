//
//  WordScrambleMenuView.swift
//  Board Solver
//
//  Created by Henry Robbins on 7/16/24.
//

import SwiftUI

struct WordScrambleMenuView: View {
    @Environment(\.dismiss) private var dismiss
    @State var pc = -1
    @State var game = "scramble"
    
    var body: some View {
        NavigationView {
            
            ZStack {
                //Background
                Color.white.ignoresSafeArea(.all)
                
                VStack {
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Label("", image: "Back_prompt")
                        }
                        .padding()
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                    NavigationLink
                    {
                        BufferView(playerColor: $pc, g: $game)
                            .navigationBarTitle("")
                            .navigationBarHidden(true)
                    } label: {
                        Label("", image: "yellow_prompt")
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    WordScrambleMenuView()
}
