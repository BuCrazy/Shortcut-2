import SwiftUI

enum DiscoveryDesctination: Hashable {
    case swiperMain
    case quizIntro
    case quizView
    case quizSummary(correctAnswers: Int, incorrectAnswers: Int)
    case reinforcement
}

struct SwiperScreen: View {
    
    @EnvironmentObject var activityLogDataLayer: ActivityCalendar
    @EnvironmentObject var storedNewWordItemsDataLayer: storedNewWordItems
    @EnvironmentObject var storedStatesDataLayer: storedStates
    @EnvironmentObject var goalsManager: GoalsManager
    
    @AppStorage("wordsPerDiscoverySetting_key") var wordsPerDiscoverySetting: Int = 30
    @AppStorage("wordsPerRevisionSetting_key") var wordsPerRevisionSetting: Int = 30
    
    @AppStorage("wordsDiscoveredDuringTheCurrentDiscoverySession_key") var wordsDiscoveredDuringTheCurrentDiscoverySession: Int = 0
    @AppStorage("wordsDiscoveredDuringTheCurrentRevisionSession_key") var wordsDiscoveredDuringTheCurrentRevisionSession: Int = 0
    
    @AppStorage("currentLearningMode_key") var currentLearningMode: String = "discovery"
    @AppStorage("currentLevelSelected_key") var currentLevelSelected: String = "elementary"
    
    @AppStorage("isFirstAppLaunch") var isFirstAppLaunch: Bool = true
    @AppStorage("hasShownGoalListSheet_key") private var hasShownGoalListSheet: Bool = false
    @AppStorage("currentDiscoveryView_key") private var currentDiscoveryViewString: String = "" //TEST October 1
   
    @AppStorage("quizSummaryCorrect_key") private var quizSummaryCorrect: Int = 0  //TEST October 1 (delete to come back)
    @AppStorage("quizSummaryIncorrect_key") private var quizSummaryIncorrect: Int = 0  //TEST October 1 (delete to come back)

    @State private var showGoalList: Bool = false
    @State private var currentView: DiscoveryDesctination? = nil //TEST September 4 (delete this var to get back)
    @State private var shouldTransition = false
    var body: some View {
    
        ZStack {
            Group {
                switch currentView {
                case .quizIntro:
                    QuizIntroView(currentView: $currentView)
                case .quizView:
                      //QuizView(storedWords: storedNewWordItemsDataLayer/*, currentView: $currentView*/)
                    QuizView_Alt(storedWords: storedNewWordItemsDataLayer, currentView: $currentView)
                case .quizSummary(let correctAnswers, let incorrectAnswers):
                    QuizSummaryView(correctAnswerNumber: .constant(correctAnswers), incorrectAnswerNumber: .constant(incorrectAnswers), isQuizAlreadyStarted: .constant(true), isQuizFinished: .constant(true), currentView: $currentView)
                case .reinforcement:
                    ReinforcementView(currentView: $currentView)
                case .swiperMain:
                    SwiperMainView()
                        .environmentObject(goalsManager)
                case nil:
                    SwiperMainView()
                        .environmentObject(goalsManager)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: currentView)
        }
        
        //TEST OCTOBER 1  (delete this onChange block to get back)
        .onChange(of: currentView) {_, newValue  in
            switch newValue {
                case .quizIntro:
                    currentDiscoveryViewString = "quizIntro"
                    print("💾 Saved state: quizIntro")
            case .swiperMain:
                currentDiscoveryViewString = "swiperMain"
                print("💾 Saved state: swiperMain")
            case .quizView:
                currentDiscoveryViewString = "quizView"
                print("💾 Saved state: quizView")
            case .reinforcement:
                currentDiscoveryViewString = "reinforcement"
                print("💾 Saved state: reinforcement")
            case .quizSummary(let correctAnswers, let incorrectAnswers):
                currentDiscoveryViewString = "quizSummary"
                quizSummaryCorrect = correctAnswers
                quizSummaryIncorrect = incorrectAnswers
                print("💾 Saved state: quizSummary (correct: \(correctAnswers), incorrect: \(incorrectAnswers))")
            case nil:
                currentDiscoveryViewString = ""
                        
            }
        }
        .onChange(of: wordsDiscoveredDuringTheCurrentDiscoverySession) { _, newValue in
            let wordsBeingLearnedCount = storedNewWordItemsDataLayer.totalWordCount(for: currentLevelSelected)
            
            if newValue >= wordsPerDiscoverySetting && wordsBeingLearnedCount >= wordsPerRevisionSetting && !shouldTransition { //TEST September 9 remove the last condition to get back
                shouldTransition = true //TEST September 9 remove this line to get back
                
                withAnimation(.easeOut(duration: 0.3)) {
                    currentView = .quizIntro
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    wordsDiscoveredDuringTheCurrentDiscoverySession = 0
                    shouldTransition = false
                    print("🎯 Counter reset after transition completed")
                }
            }
            
        }
       

    //    }
        .onAppear{
         
            //          try! activityLogDataLayer.loadDataFromJSON()
            print("🔍 SwiperScreen onAppear - currentLearningMode: \(currentLearningMode)")
            if currentDiscoveryViewString == "quizIntro" {
                currentView = .quizIntro
                print("🎯 Restored to Quiz Intro from persisted state")
                return
            } else if currentDiscoveryViewString == "reinforcement" {
                currentView = .reinforcement
                print("🎯 Restored to Reinforcement from persisted state")
                return
            } else if currentDiscoveryViewString == "quizSummary" {
                currentView = .quizSummary(
                        correctAnswers: quizSummaryCorrect,
                        incorrectAnswers: quizSummaryIncorrect
                )
                print("🎯 Restored to Quiz Summary with values (correct: \(quizSummaryCorrect), incorrect: \(quizSummaryIncorrect))")
                return
            }
          
                
                do {
                    if let quizState = try storedNewWordItemsDataLayer.loadQuizState() {
                        if quizState.isQuizFinished {
                        // If quiz is finished, show summary
                            currentView = .quizSummary(
                                correctAnswers: quizState.correctAnswerCount,
                                incorrectAnswers: quizState.incorrectAnswerCount
                            )
                        } else if currentDiscoveryViewString == "quizView" {
                            // If quiz is in progress, show quiz view
                            currentView = .quizView
                            print("🎯 Restored navigation to quiz state")
                        } else {
                            currentView = .swiperMain
                            print("🎯 Defaulting to SwiperMainView")
                        }
                    } else {
                        // No quiz state, default to swiper
                        currentView = .swiperMain
                        print("🎯 No quiz state found, defaulting to SwiperMainView")
                    }
                } catch {
                    print("Error loading quiz state: \(error)")
                    currentView = .swiperMain

                }
           // }
            
            //TEST October 1
            
            
            if !hasShownGoalListSheet {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                print("=== SwiperScreen onAppear ===")
                print("isFirstAppLaunch: \(isFirstAppLaunch)")
                print("hasShownGoalListSheet: \(hasShownGoalListSheet)")
                print("✅ Conditions met - will show goal list sheet in 1 second")
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                    
                    if !hasShownGoalListSheet && !isFirstAppLaunch {
                        print("🎯 Actually showing goal list sheet now")

                        showGoalList = true
                        hasShownGoalListSheet = true
                    }
                }
            }

            if isFirstAppLaunch == false {
                storedNewWordItemsDataLayer.saveData()
            }
            
          

           
        }
        .sheet(isPresented: $showGoalList) {
          GoalListView(isSheet: $showGoalList)
                .presentationDetents([.large])
            
        }
        
    }
    
   

    

}

#Preview {
    SwiperScreen()
        .environmentObject(ActivityCalendar())
        .environmentObject(storedNewWordItems())
        .environmentObject(storedStates())
}
