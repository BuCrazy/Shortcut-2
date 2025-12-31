//
//  QuizIntro_Alt.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 11/16/25.
//

import SwiftUI

struct QuizIntro_Alt: View {
    @AppStorage("currentLevelSelected_key") var currentLevelSelected: String = "elementary"
    @AppStorage("weeklySwipeCount") var weeklySwipeCount: Int = 0
    
    @EnvironmentObject var storedNewWordItemsDataLayer: storedNewWordItems
    @EnvironmentObject var goalsManager: GoalsManager
    @Binding var currentView: DiscoveryDesctination? //TEST September 4 (delete this var to get back)
    
    @State private var appeared: Bool = false
    @State private var rotationAmount: Double = 360
   
    let deviceSize = LayoutSize.current()
    let screenHeight = UIScreen.main.bounds.height
    var body: some View {
        ZStack(alignment: .top) {
            Color("BackgroundColor").ignoresSafeArea()
            VStack() {
                //NOTE: Page Title
                VStack(alignment: .leading) {
                    Text("Discovery")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color("Textprimary"))
                        .multilineTextAlignment(.leading)
                        .padding(.top,deviceSize.topHeadingSpace)
                }
                .padding(.horizontal, 16)
                
                //NOTE: A-Spot
                ZStack {
                    StripedBG()
                    switchLevelSymbol()
                }
                .padding(.bottom,16)
                
                VStack{
                    OnboardingMessage()
                }
                Spacer().frame(height: deviceSize.topPadding)
                
                //NOTE:Counter or Goal Cards
                VStack {
                  QI_GoalReporter(goalsManager: goalsManager)
                    //DiscoveryCounter(discoveredThisWeek: $weeklySwipeCount)
                }
                Spacer().frame(height: deviceSize.topPadding)
                
                //NOTE: Button
                VStack {
                    Button (action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentView = .quizView
                        }
                    }) {
                        CTAButton(buttonText: "Let's Go!")
                            .padding(.horizontal, 16)
                        }
                        .animation(.none, value: UUID())
                }
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

extension LayoutSize {
    var topHeadingSpace: CGFloat {
        switch self {
        case .compact:
            return 18
        case .standard:
            return 20
        case .spacious:
            return 20
        }
    }
}

struct QuizIntro_Alt_Previews: PreviewProvider {
    static var previews: some View {
        let mockStoredItems = storedNewWordItems()
        let mockGoalsManager = GoalsManager(storedItems: mockStoredItems)
        
        return QuizIntro_Alt(currentView: .constant(.quizIntro))
            .environmentObject(mockStoredItems)
            .environmentObject(mockGoalsManager)
    }
}
