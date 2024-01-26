//
//  QuizIntroView.swift
//  Shortcut 2
//
//  Created by Pavlo Bilashchuk on 1/14/24.
//

import SwiftUI

struct QuizIntroView: View {
    @AppStorage("currentLevelSelected_key") var currentLevelSelected: String = "elementary"
    
    @State private var appeared: Bool = false
    @State private var rotationAmount: Double = 360
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundColor").ignoresSafeArea()
                VStack {
                    //NOTE: A-Spot
                    VStack {
                        Spacer()
                        ZStack{
                            Spacer()
                            StripedBG()
                                .frame(maxHeight: 250)
                            
                            switchLevelSymbol()
                            Spacer()
                        }
                    }
                    
                    //NOTE: Message
                    VStack{
                        OnboardingMessage()
                        Spacer().frame(height: screenHeight > 700 ? 40 : 24)
                    }
                    
                    //NOTE: Counter
                    VStack {
                        Spacer()
                        HStack(alignment: .center) {
                            DiscoveryCounter()
                        }
                        Spacer()
                    }
                    .padding(.bottom, 16)
                    
                    //NOTE: Button
                    VStack {
                        NavigationLink(destination:  SettingsView()) {
                            CTAButton(buttonText: "Let's Go!")
                                .padding(.horizontal, 16)
                        }
                        Spacer()
                    }
                    .padding(.top, screenHeight > 700 ? 48 : 0)
                    Spacer()
                    
                }
                .navigationTitle(Text ("Discovery")).navigationBarBackButtonHidden(false)
            }
        }//NOTE: NavigationStack ends here
    }
    @ViewBuilder
    func switchLevelSymbol() -> some View {
        switch currentLevelSelected {
        case "elementary":
            ElementarySymbolView()
                .rotationEffect(appeared ? .zero : .degrees(rotationAmount))
                .onAppear {
                    withAnimation(Animation.linear(duration: 15).repeatForever(autoreverses: false)) {
                        appeared.toggle()
                    }
                }
        case "beginner":
            BeginnerSymbolView()
                .rotationEffect(appeared ? .zero : .degrees(rotationAmount))
                .onAppear {
                    withAnimation(Animation.linear(duration: 15).repeatForever(autoreverses: false)) {
                        appeared.toggle()
                    }
                }
        case "intermediate":
            IntermediateSymbolView()
                .rotationEffect(appeared ? .zero : .degrees(rotationAmount))
                .onAppear {
                    withAnimation(Animation.linear(duration: 15).repeatForever(autoreverses: false)) {
                        appeared.toggle()
                    }
                }
        case "Advanced":
            AdvanceSymbolView()
                .rotationEffect(appeared ? .zero : .degrees(rotationAmount))
                .onAppear {
                    withAnimation(Animation.linear(duration: 15).repeatForever(autoreverses: false)) {
                        appeared.toggle()
                    }
                }
        case "Native-Like":
            NativeLikeSymbolView()
                .rotationEffect(appeared ? .zero : .degrees(rotationAmount))
                .onAppear {
                    withAnimation(Animation.linear(duration: 15).repeatForever(autoreverses: false)) {
                        appeared.toggle()
                    }
                }
        case "Born in England":
            BornInEnglandSymbolView()
                .rotationEffect(appeared ? .zero : .degrees(rotationAmount))
                .onAppear {
                    withAnimation(Animation.linear(duration: 15).repeatForever(autoreverses: false)) {
                        appeared.toggle()
                    }
                }
        default:
            Text("No data to display")
        }
    }
}

#Preview {
    QuizIntroView()
}
