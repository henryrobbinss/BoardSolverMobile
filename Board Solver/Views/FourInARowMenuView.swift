import SwiftUI

struct FourInARowMenuView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var yellow: Int = 1
    @State var red: Int = 0
    @State var game = "four"
    @State var letters: String = ""
    
    init() {
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
                            
                            Spacer()
                            
                            Text("Please Select Which\nColor Went First")
                                .font(.custom("PatrickHandSC-Regular", size: 40))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                            
                            HStack
                            {
                                NavigationLink
                                {
                                    BufferView(playerColor: $yellow, g: $game, letters: $letters)
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
                                    BufferView(playerColor: $red, g: $game, letters: $letters)
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
                            Spacer()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    FourInARowMenuView()
}
