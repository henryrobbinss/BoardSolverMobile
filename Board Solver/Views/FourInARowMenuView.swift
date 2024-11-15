//
//  MenuView.swift
//  Board Solver
//
//  Created by Alex Mattoni on 7/12/24.
//

import SwiftUI

struct FourInARowMenuView: View
{
    @Environment(\.dismiss) private var dismiss
    @State var yellow: Int = 1
    @State var red: Int = 0
    @State var game = "four"
    @State var letters: String = ""
    @State var fastSolver = true
    
    // Disable animation transitions
    init()
    {
        UINavigationBar.setAnimationsEnabled(false)
    }
    
    var body: some View
    {
        NavigationView
        {
            // Navigation links
            ZStack
            {
                // Background
                Color.white.ignoresSafeArea(.all)
                
                
                VStack {
                    
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Rectangle()
                                .fill(.gray)
                                .frame(width: 80, height: 40)
                                .cornerRadius(15)
                                .overlay(Group{
                                    Text("BACK")
                                        .font(.custom("PatrickHandSC-Regular", size: 25))
                                        .foregroundStyle(.white)
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.black, lineWidth: 2.5)
                                    })
                        }
                        .padding()
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                    Text("Please Select Which\nColor Went First")
                        .font(.custom("PatrickHandSC-Regular", size: 40))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                
                    HStack
                    {
                        NavigationLink
                        {
                            BufferView(playerColor: $yellow, g: $game, letters: $letters, fastSolver: $fastSolver)
                                .navigationBarTitle("")
                                .navigationBarHidden(true)
                        } label: {
                            Rectangle()
                                .fill(.yellow)
                                .frame(width: 150, height: 75)
                                .cornerRadius(15)
                                .overlay(Group{
                                    Text("YELLOW")
                                        .font(.custom("PatrickHandSC-Regular", size: 40))
                                        .foregroundStyle(.white)
                                    RoundedRectangle(cornerRadius: 15)
                                                .stroke(Color.black, lineWidth: 5)
                                    })
                        }
                        
                        NavigationLink
                        {
                            BufferView(playerColor: $red, g: $game, letters: $letters, fastSolver: $fastSolver)
                                .navigationBarTitle("")
                                .navigationBarHidden(true)
                        } label:
                        {
                            Rectangle()
                                .fill(.red)
                                .frame(width: 150, height: 75)
                                .cornerRadius(15)
                                .overlay(Group{
                                    Text("RED")
                                        .font(.custom("PatrickHandSC-Regular", size: 40))
                                        .foregroundStyle(.white)
                                    RoundedRectangle(cornerRadius: 15)
                                                .stroke(Color.black, lineWidth: 5)
                                    })
                        }
                    }
                    //add toggle here
                    

                    Toggle("",isOn : $fastSolver )
                        .toggleStyle(CustomToggleStyle())
                        .padding()
                    
                    Spacer()
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct CustomToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack{
            Text("Click to Change Solver Type")
                .font(.custom("PatrickHandSC-Regular", size: 30))
                .foregroundStyle(.black)
                .offset(y: 20)
            
            Button(action: {
                configuration.isOn.toggle()
            },label: {
                Rectangle()
                    .fill(configuration.isOn ? .orange : .blue)
                    .frame(width: 300, height: 75)
                    .cornerRadius(15)
                    .overlay(Group{
                        Text(configuration.isOn ? "Fast Solver" : "Accurate Solver")
                            .font(.custom("PatrickHandSC-Regular", size: 40))
                            .foregroundStyle(configuration.isOn ? .black : .white)
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.black, lineWidth: 5)
                    })
            }
                   
                   
            )
        }
    }
}

//#Preview {
//    FourInARowMenuView()
//}
