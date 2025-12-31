//
//  QuizIntroView.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 2/28/24.
//

import SwiftUI

extension LayoutSize {
    
    var topPadding: CGFloat {
        switch self {
            case .compact:
            return 32
        case .standard:
            return 48
        case .spacious:
            return 72  //48
        }
    }
    
    var bottomPadding: CGFloat {
            switch self {
            case .compact:
                return 0
            case .standard:
                return 96
            case .spacious:
                return 96
            }
        }
    }

struct QuizIntroView: View {
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
            ZStack {
                Color("BackgroundColor").ignoresSafeArea()
                
                //Outer VStack
                VStack() {
                    Spacer().frame(height: screenHeight > 848 ? 20 : 0)
                    //View Title
                    VStack(alignment: .leading) {
                        Text("Discovery")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color("Textprimary"))
                            .multilineTextAlignment(.leading)
                    }
                    .padding(.horizontal, 16)
                
//                    //NOTE: A-Spot
                    VStack {
                        Spacer()
                        ZStack{
                            Spacer()
                            StripedBG()
                              //  .frame(maxHeight: 250)
                                .clipped() //TEST September 14 (delete this line to get back)
                            switchLevelSymbol()
                        
                            Spacer()
                        }
                    }
                    
                    //NOTE: Message
                    VStack{
                        OnboardingMessage()
                        Spacer().frame(height: screenHeight > 700 ? 40 : 24)
                    }
              // Spacer()
                    
                    //NOTE: Counter
                    VStack {
        
                        ZStack(alignment: .center) {
                            QI_GoalReporter(goalsManager: goalsManager)
                           
                           
                        }
                        .padding(.top, 24)
                       .padding(.bottom, 10)
                   
                    }
                    Spacer().frame(height: deviceSize.topPadding)
                  
                    
//                    //NOTE: Button
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
                 
                  //  .padding(.top, deviceSize.topPadding)
                    .padding(.bottom, deviceSize.bottomPadding)
                }
               
                //.navigationTitle(Text ("Discovery")).navigationBarBackButtonHidden(false)
              
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
        
        return QuizIntroView(currentView: .constant(.quizIntro))
            .environmentObject(mockStoredItems)
            .environmentObject(mockGoalsManager)
    }
}

//#Preview {
//    QuizIntroView()
//        .environmentObject(storedNewWordItems())
//}
