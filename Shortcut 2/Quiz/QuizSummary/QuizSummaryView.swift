//
//  QuizSummaryView.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 2/28/24.
//

import SwiftUI

struct QuizSummaryView: View {
    @AppStorage("currentLearningMode_key") var currentLearningMode: String = "discovery"
    @EnvironmentObject var storedNewWordItemsDataLayer: storedNewWordItems
    @EnvironmentObject var goalsManager: GoalsManager
    @Environment(\.dismiss) private var dismiss

    
    @State var feedbackColor: Color = Color.clear
    @Binding var correctAnswerNumber: Int
    @Binding var incorrectAnswerNumber: Int
    @State private var navigateToSwipePractice: Bool = false
    var sessionScore: Double {
        let totalQuestions = correctAnswerNumber + incorrectAnswerNumber
        if totalQuestions > 0 {
            let score = (Double(correctAnswerNumber) / Double(totalQuestions)) * 100
            // Format the score with one digit after the decimal point.
            return Double(String(format: "%.1f", score)) ?? 0.0
        } else {
            return 0.0 // Return 0.0 if there are no questions.
        }
    }
    
    // --- Code for saving Quiz historical data ---
    @Binding var isQuizAlreadyStarted: Bool
    @Binding var isQuizFinished: Bool
    @State private var navigateToReinforcement = false
    // --- Code for saving Quiz historical data ends ---
    
    init(correctAnswerNumber: Binding<Int>, incorrectAnswerNumber: Binding<Int>, isQuizAlreadyStarted: Binding<Bool>, isQuizFinished: Binding<Bool>) {
        self._correctAnswerNumber = correctAnswerNumber
        self._incorrectAnswerNumber = incorrectAnswerNumber
        self._isQuizAlreadyStarted = isQuizAlreadyStarted
        self._isQuizFinished = isQuizFinished
    }
    
    var body: some View {
       // NavigationStack {
            ZStack {
                Color("BackgroundColor").ignoresSafeArea()
                ScrollView {
                    VStack {
                        
//                        SummaryMessage(goalsManager: goalsManager)
//                            .padding(.vertical, 32)
                           // .padding(.horizontal, 16)
                        
                        
                        VStack(spacing: 24) {
                           SummaryMessage(goalsManager: goalsManager)
                                .padding(.vertical, 32)
                           
                            QS_GoalReporter(goalsManager: goalsManager)
                                .padding(.horizontal, 16)
                            
                            SessionStats(correctAnswerNumber: $correctAnswerNumber, incorrectAnswerNumber: $incorrectAnswerNumber, sessionScore: sessionScore)
                                .padding(.horizontal, 16)
                                .shadow(color: .black.opacity(0.16), radius: 6, x: 0, y: 5)
                            
                            HistoricalDataView(quizHistory: /*quizHistory*/ storedNewWordItems.shared.quizHistory)
                                .padding(.horizontal, 16)
                            
                            //   Text("Total Average Score: \(quizHistory.wrappedValue.totalAverage, specifier: "%.1f")%")
                            
                            // CTA Button
//                            NavigationLink(destination: ReinforcementView(), label: {
//                                CTAButton(buttonText: "To Reinforcement")//{}
//                            })
//                            .padding(.horizontal, 16)
//                            .simultaneousGesture(TapGesture().onEnded {
//                                resetQuizState()
//                                isQuizAlreadyStarted = false
//                                isQuizFinished = false //test Oct 14 2024
//                                currentLearningMode = "reinforcement"
//                            })
                            
                            //TEST Aug 25
                            Button(action: {
                                resetQuizState()
                                isQuizAlreadyStarted = false
                                isQuizFinished = false
                                currentLearningMode = "reinforcement"
                                dismiss()
                            }) {
                                CTAButton(buttonText: "To Reinforcement")

                            }
                            .padding(.horizontal, 16)

                            
                            
                        }
                        Spacer()
                        
                        
                    }
                    Spacer().frame(height: 50)
                }
                
                ZStack {
                    BCircleAnimation(feedbackColor: feedbackColor)
                        .blendMode(.screen)
                        .blur(radius: 40)
                        .offset(x: -50, y: -400)
                }

            }
            .navigationTitle(Text ("Summary"))
            .toolbarBackground(.clear, for: .navigationBar)
  //      } //NavigationStack ends
        .onAppear {
            goalsManager.updateStoredItems(storedNewWordItemsDataLayer)
            updateQuizHistoryWithScore(score: sessionScore, date: Date())
            feedbackColor = sessionScore >= 60 ? .green : .red
  
            print("Goal 2 Status \(goalsManager.goals[1].status)")

        }
        .onDisappear {
            isQuizAlreadyStarted = false
            
            // TEST June 29
            if goalsManager.goals.allSatisfy({ $0.status == .completed}) {
                goalsManager.hasShownCompletionToast = true
                goalsManager.saveState()
            }

        }
    }
    // --- Test for saving Quiz historical data ---
    func updateQuizHistoryWithScore(score: Double, date: Date) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateKey = dateFormatter.string(from: date)
            storedNewWordItems.shared.quizHistory.quizHistoricalData[dateKey] = score
            storedNewWordItems.shared.quizHistory.saveToPersistentStorage() // Ensure data is saved after update
        }
    // --- Test for saving Quiz historical data ---
    
    // This function triggers another function in the AppModel to reset the JSON file with quiz progress
    func resetQuizState() {
        do {
            try storedNewWordItems.shared.resetQuizStateForNewSession() {
                // Operations to do after reset
                DispatchQueue.main.async {
                    isQuizAlreadyStarted = false
                    // Any other operations that depend on the quiz state being reset
                }
            }
            
        } catch {
            print("Error resetting quiz state: \(error)")
        }
    }
}

struct QuizSummary_Previews: PreviewProvider {
    @State static var correctAnswerNumber: Int = 28
    @State static var incorrectAnswerNumber: Int = 2
    static var previews: some View {
        QuizSummaryView(correctAnswerNumber: .constant(correctAnswerNumber), incorrectAnswerNumber: .constant(incorrectAnswerNumber), isQuizAlreadyStarted: .constant(false), isQuizFinished: .constant(false))
            .environmentObject(storedNewWordItems.shared)
            .environmentObject(GoalsManager.shared)
            
    }
}
