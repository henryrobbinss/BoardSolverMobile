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

    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.ignoresSafeArea()

                GeometryReader { geometry in
                    VStack {
                        HStack {
                            Button {
                                dismiss()
                            } label: {
                                Image("Back_prompt")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geometry.size.width * 0.14) // Adjusted size
                            }
                            .padding(.leading, geometry.size.width * 0.05) // Adaptive padding

                            Spacer()
                        }
                        .padding(.top, geometry.size.height * 0.1) // Adaptive top padding

                        Spacer().frame(height: geometry.size.height * 0.3)

                        Text("Please Select Which\nColor Went First")
                            .font(.custom("KoHo-Medium", size: geometry.size.width * 0.055)) // Adaptive font size
                            .monospaced()
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, geometry.size.width * 0.1) // Adaptive horizontal padding

                        Spacer().frame(height: geometry.size.height * 0.02)

                        HStack(spacing: geometry.size.width * 0.02) { // Adaptive spacing
                            NavigationLink {
                                BufferView(playerColor: $yellow, g: $game, letters: $letters)
                                    .toolbar(.hidden, for: .navigationBar)
                            } label: {
                                
                                Image("yellow_prompt")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geometry.size.width * 0.35) // Adjusted size
                            }   

                            NavigationLink {
                                BufferView(playerColor: $red, g: $game, letters: $letters)
                                    .toolbar(.hidden, for: .navigationBar)
                            } label: {
                                Image("red_prompt")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geometry.size.width * 0.35) // Adjusted size
                            }
                        }

                        Spacer()
                    }
                }
            }
        }
    }
}

#Preview {
    FourInARowMenuView()
}
