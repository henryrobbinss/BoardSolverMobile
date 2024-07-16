//
//  WordScrambleMenuView.swift
//  Board Solver
//
//  Created by Henry Robbins on 7/16/24.
//

import SwiftUI

struct WordScrambleMenuView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
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
                
                Image(systemName: "exclamationmark.triangle.fill.multicolor")
                
                Text("Coming Soon!")
                    .font(.custom("KoHo-Medium", size: 40))
                    .foregroundColor(Color.black)
                    .monospacedDigit()
                
                Spacer()
            }
        }
    }
}

#Preview {
    WordScrambleMenuView()
}
