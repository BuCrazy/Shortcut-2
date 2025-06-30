//
//  QuizIntroView.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 2/28/24.
//

import SwiftUI

struct QuizIntroView: View {
    @AppStorage("currentLevelSelected_key") var currentLevelSelected: String = "elementary"
    @AppStorage("weeklySwipeCount") var weeklySwipeCount: Int = 0
    
    @EnvironmentObject var storedNewWordItemsDataLayer: storedNewWordItems
    @EnvironmentObject var goalsManager: GoalsManager
    
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
                       // Spacer()
                        
                        ZStack(alignment: .center) {
//                            GoalToast_2(goalsManager: goalsManager)
//                                .padding(.horizontal, 32)
//                                .offset(x: 0, y: -16)
//                            
//                            GoalToast_1()
//                                .padding(.horizontal, 16)
//                            DiscoveryCounter(discoveredThisWeek: $weeklySwipeCount)
                            QI_GoalReporter(goalsManager: goalsManager)
                        }
                        .padding(.top, 24)
                       // Spacer()
                    }
                   // .padding(.bottom, 16)
                    
                    //NOTE: Button
                    VStack {
                       // Spacer()
                        NavigationLink(destination:  QuizView(storedWords: storedNewWordItemsDataLayer)) {
                            CTAButton(buttonText: "Let's Go!")
                                .padding(.horizontal, 16)
                        }
                        .animation(.none, value: UUID())
                        Spacer()
                    }
                    .padding(.top, screenHeight > 700 ? 48 : 0)
                    Spacer()
                }
                .navigationTitle(Text ("Discovery")).navigationBarBackButtonHidden(false)
              
            }
        }
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

struct QuizIntroView_Previews: PreviewProvider {
    static var previews: some View {
        let mockStoredItems = storedNewWordItems()
        let mockGoalsManager = GoalsManager(storedItems: mockStoredItems)
        
        return QuizIntroView()
            .environmentObject(mockStoredItems)
            .environmentObject(mockGoalsManager)
    }
}

//#Preview {
//    QuizIntroView()
//        .environmentObject(storedNewWordItems())
//}
