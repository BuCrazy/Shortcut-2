import SwiftUI
import Charts
import Marquee



struct LevelSwitcherSheet: View {
    @AppStorage("levelSwitchSheetLevelSelected_key") var levelSwitchSheetLevelSelected = 1
    @AppStorage("currentLevelSelected_key") var currentLevelSelected: String = "elementary"
    @AppStorage("levelSwitchSheetShown_key") var levelSwitchSheetShown: Bool = false
    @AppStorage("currentLearningMode_key") var currentLearningMode: String = "discovery"
    @State private var navigateGoalList: Bool = false
    @State private var isGoalListSheet: Bool = false
    
    // Chart Data
    @State var level_selector_Data: [LevelSelectorData] = level_selector_data
    @State private var animationAmount = 1.0
    @State private var isAnimating: Bool = false
    
    // Opacity States
    @State var opacity1: Double = 0
    @State var opacity2: Double = 0
    @State var opacity3: Double = 0
    @State var opacity4: Double = 0
    @State var opacity5: Double = 0
    @State var opacity6: Double = 0
    
    @State private var currentOffset: CGFloat = 0
    @State private var timer: Timer?
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("basicOnboardingPassed_key") private var basicOnboardingPassed: Bool = false
    
    // Отдельно переменная, откуда из предыдущего экрана передаётся выбранный код языка. Из неё берётся этот код и подставляется в languageCodeForUse по onAppear данного вью:
    var languageCodePassed: String
    @AppStorage("nativeLanguageSelectedID_key") var languageCodeForUse: String = ""
    var isShortVersion: Bool
   
    @State var feedbackColor: Color = Color.clear
    
    
    var body: some View {
        NavigationStack{
            VStack {
                ZStack(alignment: .top) {
                    P171_CircleAnimation(feedbackColor: feedbackColor)
                        .blendMode(.screen)
                        .blur(radius: 28)
                        .offset(y: -400)
                        .opacity(0.4)

                    VStack{
                        
                        headerView
                        
                        marqueeSection
                        Spacer()
                            .frame(height: 22)
                        
                        // Код графика
                        chartSection
                        // Тут заканчивается область Z-Stack со слоями
                        VStack{
                            Text("Word Ranking")
                                .font(.system(size: 12))
                                .foregroundStyle(Color("secondaryFontColor"))
                                .offset(y: 7)
                        }
                        Spacer()
                            .frame(height:32)
                        TabView(selection: $levelSwitchSheetLevelSelected){
                            VStack{
                                VStack{
                                    Image("levelicons_elementary")
                                        .frame(width: 42, height: 42)
                                    Spacer()
                                        .frame(height: 12)
                                    Text("Elementary")
                                        .font(.system(size: 24))
                                        .fontWeight(.bold)
                                        .foregroundStyle(Color("MainFontColor"))
                                    Spacer()
                                        .frame(height: 4)
                                    Text("First 500 words")
                                        .foregroundStyle(Color("secondaryFontColor"))
                                        .font(.system(size: 12))
                                    Spacer()
                                        .frame(height: 12)
                                    Text("Absolute basics. Not enough to start speaking.")
                                        .font(.system(size: 14))
                                        .foregroundStyle(Color("MainFontColor"))
                                        .multilineTextAlignment(.center)
                                }.padding([.leading, .trailing], 16)
                            }.tag(1)
                            VStack{
                                VStack{
                                    Image("levelicons_beginner")
                                        .frame(width: 42, height: 42)
                                    Spacer()
                                        .frame(height: 12)
                                    Text("Beginner")
                                        .font(.system(size: 24))
                                        .fontWeight(.bold)
                                        .foregroundStyle(Color("MainFontColor"))
                                    Spacer()
                                        .frame(height: 4)
                                    Text("Top 501 - 2 000 words")
                                        .foregroundStyle(Color("secondaryFontColor"))
                                        .font(.system(size: 12))
                                    Spacer()
                                        .frame(height: 12)
                                    Text("Enough to be able to express 80 % of your ideas.")
                                        .font(.system(size: 14))
                                        .foregroundStyle(Color("MainFontColor"))
                                        .multilineTextAlignment(.center)
                                }.padding([.leading, .trailing], 16)
                            }.tag(2)
                            VStack{
                                VStack{
                                    Image("levelicons_intermediate")
                                        .frame(width: 42, height: 42)
                                    Spacer()
                                        .frame(height: 12)
                                    Text("Intermediate")
                                        .font(.system(size: 24))
                                        .fontWeight(.bold)
                                        .foregroundStyle(Color("MainFontColor"))
                                    Spacer()
                                        .frame(height: 4)
                                    Text("Top 2 001 - 5 000 words")
                                        .foregroundStyle(Color("secondaryFontColor"))
                                        .font(.system(size: 12))
                                    Spacer()
                                        .frame(height: 12)
                                    Text("Enough to work in an English-speaking country")
                                        .font(.system(size: 14))
                                        .foregroundStyle(Color("MainFontColor"))
                                        .multilineTextAlignment(.center)
                                }.padding([.leading, .trailing], 16)
                            }.tag(3)
                            VStack{
                                VStack{
                                    Image("levelicons_advanced")
                                        .frame(width: 42, height: 42)
                                    Spacer()
                                        .frame(height: 12)
                                    Text("Advanced")
                                        .font(.system(size: 24))
                                        .fontWeight(.bold)
                                        .foregroundStyle(Color("MainFontColor"))
                                    Spacer()
                                        .frame(height: 4)
                                    Text("Top 5 001 - 8 500 words")
                                        .foregroundStyle(Color("secondaryFontColor"))
                                        .font(.system(size: 12))
                                    Spacer()
                                        .frame(height: 12)
                                    Text("Enough to make an excellent impression on a date.")
                                        .font(.system(size: 14))
                                        .foregroundStyle(Color("MainFontColor"))
                                        .multilineTextAlignment(.center)
                                }.padding([.leading, .trailing], 16)
                            }.tag(4)
                            VStack{
                                VStack{
                                    Image("levelicons_nativelike")
                                        .frame(width: 42, height: 42)
                                    Spacer()
                                        .frame(height: 12)
                                    Text("Native-like")
                                        .font(.system(size: 24))
                                        .fontWeight(.bold)
                                        .foregroundStyle(Color("MainFontColor"))
                                    Spacer()
                                        .frame(height: 4)
                                    Text("Top 8 501 - 12 500 words")
                                        .foregroundStyle(Color("secondaryFontColor"))
                                        .font(.system(size: 12))
                                    Spacer()
                                        .frame(height: 12)
                                    Text("Enough to communicate up to 99 % of your ideas.")
                                        .font(.system(size: 14))
                                        .foregroundStyle(Color("MainFontColor"))
                                        .multilineTextAlignment(.center)
                                }.padding([.leading, .trailing], 16)
                            }.tag(5)
                            VStack{
                                VStack{
                                   Image("shakespeare")
                                        .resizable()
                                        .frame(width: 42, height: 42)
//                                        .background(
//                                            LinearGradient(
//                                                stops: [
//                                                    Gradient.Stop(color: Color(red: 0.76, green: 0.99, blue: 0.96), location: 0.00),
//                                                    Gradient.Stop(color: Color(red: 0.71, green: 0.97, blue: 0.9), location: 0.60),
//                                                    Gradient.Stop(color: Color(red: 0.57, green: 0.92, blue: 0.78), location: 1.00),
//                                                ],
//                                                startPoint: UnitPoint(x: 0.5, y: 0),
//                                                endPoint: UnitPoint(x: 0.5, y: 1)
//                                            )
//                                        )
//                                        .cornerRadius(60)
  //                                      .shadow(color: .black.opacity(0.11), radius: 21.86598, x: 9.71821, y: 9.71821)
//                                        .shadow(color: .black.opacity(0.09), radius: 8.50344, x: 4.85911, y: 4.85911)
                                        .shadow(color: Color(red: 0.58, green: 0.89, blue: 0.76).opacity(0.5), radius: 6, x: 0, y: 2)
                                       
                                    Spacer()
                                        .frame(height: 12)
                                    Text("Shakespeare")
                                        .font(.system(size: 24))
                                        .fontWeight(.bold)
                                        .foregroundStyle(Color("MainFontColor"))
                                    Spacer()
                                        .frame(height: 4)
                                    Text("Top 12 501 - 20 000 words")
                                        .foregroundStyle(Color("secondaryFontColor"))
                                        .font(.system(size: 12))
                                    Spacer()
                                        .frame(height: 12)
                                    Text("Words that aren't really useful in conversations.")
                                        .font(.system(size: 14))
                                        .foregroundStyle(Color("MainFontColor"))
                                        .multilineTextAlignment(.center)
                                }.padding([.leading, .trailing], 16)
                            }.tag(6)
                        }
                        .frame(height: 150)
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
                        Spacer()
                            .frame(height:32)
                        VStack{
                            switch levelSwitchSheetLevelSelected {
                            case 1:
                                Button(
                                    action: {
                                        switchToLevel(level: "elementary")
                                        //                        currentLevelSelected = "elementary"
                                        //                        levelSwitchSheetShown = false
                                        basicOnboardingPassed = true
                                        presentationMode.wrappedValue.dismiss() //TEST Aug 11
                                        //navigateGoalList = true
                                    },
                                    label: {
                                        Text("Choose Elementary")
                                            .frame(width: 358, height: 52)
                                            .foregroundColor(.white)
                                            .background(Color("switchLevelButtonColor"))
                                            .cornerRadius(26)
                                            .font(Font.custom("Avenir", size: 16))
                                    }
                                )

                            case 2:
                                Button(
                                    action: {
                                        switchToLevel(level: "beginner")
                                        //                        currentLevelSelected = "beginner"
                                        //                        levelSwitchSheetShown = false
                                         basicOnboardingPassed = true
                                         presentationMode.wrappedValue.dismiss() //TEST Aug 11
                                         //navigateGoalList = true
                                    },
                                    label: {
                                        Text("Choose Beginner")
                                            .frame(width: 358, height: 52)
                                            .foregroundColor(.white)
                                            .background(Color("switchLevelButtonColor"))
                                            .cornerRadius(26)
                                            .font(Font.custom("Avenir", size: 16))
                                    }
                                )
                            case 3:
                                Button(
                                    action: {
                                        switchToLevel(level: "intermediate")
                                        //                            currentLevelSelected = "intermediate"
                                        //                            levelSwitchSheetShown = false
                                         basicOnboardingPassed = true
                                         presentationMode.wrappedValue.dismiss() //TEST Aug 11
                                        // navigateGoalList = true
                                    },
                                    label: {
                                        Text("Choose Intermediate")
                                            .frame(width: 358, height: 52)
                                            .foregroundColor(.white)
                                            .background(Color("switchLevelButtonColor"))
                                            .cornerRadius(26)
                                            .font(Font.custom("Avenir", size: 16))
                                    }
                                )
                            case 4:
                                Button(
                                    action: {
                                        //                        currentLevelSelected = "advanced"
                                        switchToLevel(level: "advanced")
                                        basicOnboardingPassed = true
                                        presentationMode.wrappedValue.dismiss()
                                        // navigateGoalList = true
                                    },
                                    label: {
                                        Text("Choose Advanced")
                                            .frame(width: 358, height: 52)
                                            .foregroundColor(.white)
                                            .background(Color("switchLevelButtonColor"))
                                            .cornerRadius(26)
                                            .font(Font.custom("Avenir", size: 16))
                                    }
                                )
                            case 5:
                                Button(
                                    action: {
                                        //                        currentLevelSelected = "nativelike"
                                        switchToLevel(level: "nativelike")
                                        basicOnboardingPassed = true
                                         presentationMode.wrappedValue.dismiss()
                                        // navigateGoalList = true
                                    },
                                    label: {
                                        Text("Choose Native-like")
                                            .frame(width: 358, height: 52)
                                            .foregroundColor(.white)
                                            .background(Color("switchLevelButtonColor"))
                                            .cornerRadius(26)
                                            .font(Font.custom("Avenir", size: 16))
                                    }
                                )
                            case 6:
                                Button(
                                    action: {
                                        //                        currentLevelSelected = "shaakespeare"
                                        switchToLevel(level: "shaakespeare")
                                        basicOnboardingPassed = true
                                         presentationMode.wrappedValue.dismiss() //TEST Aug 11
                                        // navigateGoalList = true
                                    },
                                    label: {
                                        Text("Choose Shakespeare")
                                            .frame(width: 358, height: 52)
                                            .foregroundColor(.white)
                                            .background(Color("switchLevelButtonColor"))
                                            .cornerRadius(26)
                                            .font(Font.custom("Avenir", size: 16))
                                    }
                                )
                            default:
                                Button(
                                    action: {
                                        switchToLevel(level: "elementary")
                                        // currentLevelSelected = "elementary"
                                        navigateGoalList = true
                                    },
                                    label: {
                                        Text("Switch to Elementary")
                                            .frame(width: 358, height: 52)
                                            .foregroundColor(.white)
                                            .background(Color("switchLevelButtonColor"))
                                            .cornerRadius(26)
                                            .font(Font.custom("Avenir", size: 16))
                                    }
                                )
                            }
                        }
                        Spacer()
                            .frame(height:24)
                        VStack{
                            HStack{
                                // Отдельно по кружочку для каждого слайда
                                Spacer()
                                    .frame(width:12, height: 24)
                                VStack{
                                    Circle()
                                        .frame(width: 8, height: 8)
                                        .foregroundColor(levelSwitchSheetLevelSelected == 1 ? Color("Textprimary") : Color("Surfacehigh-contrast"))
                                        .animation(.easeInOut(duration: 0.3), value: levelSwitchSheetLevelSelected)
                                }
                                Spacer()
                                    .frame(width:8, height: 24)
                                VStack{
                                    Circle()
                                        .frame(width: 8, height: 8)
                                        .foregroundColor(levelSwitchSheetLevelSelected == 2 ? Color("Textprimary") : Color("Surfacehigh-contrast"))
                                        .animation(.easeInOut(duration: 0.3), value: levelSwitchSheetLevelSelected)
                                }
                                Spacer()
                                    .frame(width:8, height: 24)
                                VStack{
                                    Circle()
                                        .frame(width: 8, height: 8)
                                        .foregroundColor(levelSwitchSheetLevelSelected == 3 ? Color("Textprimary") : Color("Surfacehigh-contrast"))
                                        .animation(.easeInOut(duration: 0.3), value: levelSwitchSheetLevelSelected)
                                }
                                Spacer()
                                    .frame(width:8, height: 24)
                                VStack{
                                    Circle()
                                        .frame(width: 8, height: 8)
                                        .foregroundColor(levelSwitchSheetLevelSelected == 4 ? Color("Textprimary") : Color("Surfacehigh-contrast"))
                                        .animation(.easeInOut(duration: 0.3), value: levelSwitchSheetLevelSelected)
                                }
                                Spacer()
                                    .frame(width:8, height: 24)
                                VStack{
                                    Circle()
                                        .frame(width: 8, height: 8)
                                        .foregroundColor(levelSwitchSheetLevelSelected == 5 ? Color("Textprimary") : Color("Surfacehigh-contrast"))
                                        .animation(.easeInOut(duration: 0.3), value: levelSwitchSheetLevelSelected)
                                }
                                Spacer()
                                    .frame(width:8, height: 24)
                                VStack{
                                    Circle()
                                        .frame(width: 8, height: 8)
                                        .foregroundColor(levelSwitchSheetLevelSelected == 6 ? Color("Textprimary") : Color("Surfacehigh-contrast"))
                                        .animation(.easeInOut(duration: 0.3), value: levelSwitchSheetLevelSelected)
                                    
                                }
                                Spacer()
                                    .frame(width:12, height: 24)
                            }
                            .background(Color("Surface-component-parts"))
                            .cornerRadius(140)
                        }
                        Spacer()
                    }
                    .onAppear {
                        switch levelSwitchSheetLevelSelected {
                        case 1:
                            withAnimation(.easeIn(duration: 0.8)) {
                                opacity1 = 1
                                opacity2 = 0
                                opacity3 = 0
                                opacity4 = 0
                                opacity5 = 0
                                opacity6 = 0
                            }
                        case 2:
                            withAnimation(.easeIn(duration: 0.8)) {
                                opacity1 = 0
                                opacity2 = 1
                                opacity3 = 0
                                opacity4 = 0
                                opacity5 = 0
                                opacity6 = 0
                            }
                        case 3:
                            withAnimation(.easeIn(duration: 0.8)) {
                                opacity1 = 0
                                opacity2 = 0
                                opacity3 = 1
                                opacity4 = 0
                                opacity5 = 0
                                opacity6 = 0
                            }
                        case 4:
                            withAnimation(.easeIn(duration: 0.8)) {
                                opacity1 = 0
                                opacity2 = 0
                                opacity3 = 0
                                opacity4 = 1
                                opacity5 = 0
                                opacity6 = 0
                            }
                        case 5:
                            withAnimation(.easeIn(duration: 0.8)) {
                                opacity1 = 0
                                opacity2 = 0
                                opacity3 = 0
                                opacity4 = 0
                                opacity5 = 1
                                opacity6 = 0
                            }
                        case 6:
                            withAnimation(.easeIn(duration: 0.8)) {
                                opacity1 = 0
                                opacity2 = 0
                                opacity3 = 0
                                opacity4 = 0
                                opacity5 = 0
                                opacity6 = 1
                            }
                        default:
                            withAnimation(.easeIn(duration: 0.8)) {
                                opacity1 = 1
                                opacity2 = 0
                                opacity3 = 0
                                opacity4 = 0
                                opacity5 = 0
                                opacity6 = 0
                            }
                        }
                    }
                    .onChange(of:levelSwitchSheetLevelSelected) {
                        switch levelSwitchSheetLevelSelected {
                        case 1:
                            withAnimation(.easeIn(duration: 0.5)) {
                                opacity1 = 1
                                opacity2 = 0
                                opacity3 = 0
                                opacity4 = 0
                                opacity5 = 0
                                opacity6 = 0
                            }
                        case 2:
                            withAnimation(.easeIn(duration: 0.5)) {
                                opacity1 = 0
                                opacity2 = 1
                                opacity3 = 0
                                opacity4 = 0
                                opacity5 = 0
                                opacity6 = 0
                            }
                        case 3:
                            withAnimation(.easeIn(duration: 0.5)) {
                                opacity1 = 0
                                opacity2 = 0
                                opacity3 = 1
                                opacity4 = 0
                                opacity5 = 0
                                opacity6 = 0
                            }
                        case 4:
                            withAnimation(.easeIn(duration: 0.5)) {
                                opacity1 = 0
                                opacity2 = 0
                                opacity3 = 0
                                opacity4 = 1
                                opacity5 = 0
                                opacity6 = 0
                            }
                        case 5:
                            withAnimation(.easeIn(duration: 0.5)) {
                                opacity1 = 0
                                opacity2 = 0
                                opacity3 = 0
                                opacity4 = 0
                                opacity5 = 1
                                opacity6 = 0
                            }
                        case 6:
                            withAnimation(.easeIn(duration: 0.5)) {
                                opacity1 = 0
                                opacity2 = 0
                                opacity3 = 0
                                opacity4 = 0
                                opacity5 = 0
                                opacity6 = 1
                            }
                        default:
                            withAnimation(.easeIn(duration: 0.5)) {
                                opacity1 = 1
                                opacity2 = 0
                                opacity3 = 0
                                opacity4 = 0
                                opacity5 = 0
                                opacity6 = 0
                            }
                        }
                    }
                }
                .background(Color("sheetColor"))
            }
//            .navigationDestination(isPresented: $navigateGoalList) {
//                GoalListView(isSheet: $isGoalListSheet)
//                    .navigationBarBackButtonHidden(true)
//            }
            .sheet(isPresented: $navigateGoalList) {
                           GoalListView(isSheet: $navigateGoalList)
                       }

            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .onAppear{
                languageCodeForUse = languageCodePassed
                animateGraph()
            }
        }
    }
    
    
    // MARK: - View Components
    private var headerView: some View {
        VStack(alignment: .leading) {
            Spacer()
                .frame(height: 43)
            Text("Select Target Level")
                .font(.system(size: 32))
                .fontWeight(.bold)
                .foregroundStyle(Color("MainFontColor"))
            Spacer()
                .frame(height: 8)
            if !isShortVersion {
                Text("Swipe left or right to pick the one that suits your needs the most.")
                    .font(.system(size: 14))
                    .foregroundStyle(Color("MainFontColor"))
                Spacer()
                    .frame(height: 12)
            }
            Spacer()
                .frame(height: 12)
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(.top, 0)
        .padding(.leading, 20)
        .padding(.trailing, 16)
    }
    
    private var marqueeSection: some View {
            Group {
                switch levelSwitchSheetLevelSelected {
                case 1:
                    SimpleMarquee(words: LevelWords.elementaryExamples, speed: 90, movementDirection: "left")
                        .opacity(opacity1)
                    SimpleMarquee(words: LevelWords.elementaryExamples2, speed: 70, movementDirection: "left")
                        .opacity(opacity1)
                case 2:
                    SimpleMarquee(words: LevelWords.beginnerExamples, speed: 90, movementDirection: "left")
                        .opacity(opacity2)
                    SimpleMarquee(words: LevelWords.beginnerExamples2, speed: 70, movementDirection: "left")
                        .opacity(opacity2)
                case 3:
                    SimpleMarquee(words: LevelWords.intermediateExamples, speed: 90, movementDirection: "left")
                        .opacity(opacity3)
                    SimpleMarquee(words: LevelWords.intermediateExamples2, speed: 70, movementDirection: "left")
                        .opacity(opacity3)
                case 4:
                    SimpleMarquee(words: LevelWords.advancedExamples, speed: 90, movementDirection: "left")
                        .opacity(opacity4)
                    SimpleMarquee(words: LevelWords.advancedExamples2, speed: 70, movementDirection: "left")
                        .opacity(opacity4)
                case 5:
                    SimpleMarquee(words: LevelWords.nativelikeExamples, speed: 90, movementDirection: "left")
                        .opacity(opacity5)
                    SimpleMarquee(words: LevelWords.nativelikeExamples2, speed: 70, movementDirection: "left")
                        .opacity(opacity5)
                case 6:
                    SimpleMarquee(words: LevelWords.shakespeareExamples, speed: 90, movementDirection: "left")
                        .opacity(opacity6)
                    SimpleMarquee(words: LevelWords.shakespeareExamples2, speed: 70, movementDirection: "left")
                        .opacity(opacity6)
                default:
                    SimpleMarquee(words: LevelWords.elementaryExamples, speed: 90, movementDirection: "left")
                        .opacity(opacity1)
                    SimpleMarquee(words: LevelWords.elementaryExamples2, speed: 70, movementDirection: "left")
                        .opacity(opacity1)
                }
            }
        }
    
    private var chartSection: some View {
            VStack {
                HStack {
                    VStack {
                        Text("Frequency")
                            .rotationEffect(Angle(degrees: 270))
                            .font(.system(size: 12))
                            .frame(width: 60)
                            .offset(x: -4)
                            .foregroundStyle(Color("secondaryFontColor"))
                    }
                    VStack {
                        ZStack(alignment: .top) {
                            // Background dividers
                            chartBackgroundDividers
                            
                            // Charts
                            ForEach(LevelType.allCases, id: \.self) { levelType in
                                LevelChartView(
                                    levelType: levelType,
                                    levelSelectorData: $level_selector_Data,
                                    opacity: opacityForLevel(levelType)
                                )
                            }
                        }
                        .offset(x: -26)
                    }
                }
            }
        }
    
    private var chartBackgroundDividers: some View {
            Group {
                Divider()
                    .overlay(Color("secondaryCardColor"))
                Divider()
                    .overlay(Color("secondaryCardColor"))
                    .offset(y: 51)
                Divider()
                    .overlay(Color("secondaryCardColor"))
                    .offset(y: 102)
                Divider()
                    .overlay(Color("secondaryCardColor"))
                    .offset(y: 153)
            }
        }
    
    // MARK: - Helper Methods
        private func updateOpacities() {
            withAnimation(.easeIn(duration: 0.5)) {
                opacity1 = levelSwitchSheetLevelSelected == 1 ? 1 : 0
                opacity2 = levelSwitchSheetLevelSelected == 2 ? 1 : 0
                opacity3 = levelSwitchSheetLevelSelected == 3 ? 1 : 0
                opacity4 = levelSwitchSheetLevelSelected == 4 ? 1 : 0
                opacity5 = levelSwitchSheetLevelSelected == 5 ? 1 : 0
                opacity6 = levelSwitchSheetLevelSelected == 6 ? 1 : 0
            }
        }
        
        private func opacityForLevel(_ level: LevelType) -> Double {
            switch level {
            case .elementary: return opacity1
            case .beginner: return opacity2
            case .intermediate: return opacity3
            case .advanced: return opacity4
            case .nativelike: return opacity5
            case .shakespeare: return opacity6
            }
        }
    
    private func switchToLevel(level: String) {
            if currentLearningMode != "discovery" {
                currentLearningMode = "discovery"
            }
            currentLevelSelected = level
            levelSwitchSheetShown = false
    }
    func resetAnimation() {
            // Reset animation logic
            for (index, _) in level_selector_Data.enumerated() {
                level_selector_Data[index].animate = false
            }
            animateGraph(fromChange: true)
        }
    
    func animateGraph(fromChange: Bool = false) {
        for (index,_) in level_selector_Data.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * (fromChange ? 0.03 : 0.05)) {
                withAnimation(fromChange ? .easeOut(duration: 0.8) : .interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
                    level_selector_Data[index].animate = true
                }
            }
        }
    }
}


struct LevelSwitcherSheet_Preview: PreviewProvider {
    static var previews: some View {
        LevelSwitcherSheet(languageCodePassed: "ukranian", isShortVersion: false)
            .environmentObject(storedNewWordItems())
            .environmentObject(ActivityCalendar())
    }
}
