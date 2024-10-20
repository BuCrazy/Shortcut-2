//
//  QuizViewModel.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 10/13/24.
//

//import Foundation
//import SwiftUI
//
//class QuizViewModel: ObservableObject {
//    @AppStorage("currentLearningMode_key") var currentLearningMode: String = "discovery"
//    @AppStorage("currentLevelSelected_key") var currentLevelSelected: String = "elementary"
//    @AppStorage("nativeLanguageSelectedID_key") var languageCodeForUse: String = "ENUK_transl"
//    @AppStorage("wordsPerRevisionSetting_key") var wordsPerRevisionSetting: Int = 30
//    
//    @Published var quizItems: [QuizItem] = []
//    @Published var currentQuizIndex: Int = 0
//    @Published var correctAnswerNumber = 0
//    @Published var incorrectAnswerNumber = 0
//    @Published private var isQuizFinished: Bool = false
//    @Published var questionStatuses: [AnswerStatus] = []
//    @Published var selectedAnswer: String? = nil
//    @Published var showCircleAnimation: Bool = false
//    @Published var selectedAnswerCorrectness: (word: String, isCorrect: Bool)? = nil
//    @Published var auraEffectScale: CGFloat = 0.0
//    @Published var hasAnswered: Bool = false
//    @Published var feedbackColor: Color = Color.clear
//    @Published var currentVideo: URL?
//    @Published var showIndicators = false
//    @Published var showQuizCard = false
//    @Published var showAnswerOptions = false
//    @Published private var isViewLoaded = false
//    private var storedWords: storedNewWordItems
//    
//    init(storedWords: storedNewWordItems) {
//       
//        
//        print("Original Init Block. Initializing quiz")
//        print("Original Init Block. Current level selected: \(currentLevelSelected)")
//        
//        //NOTE: Fetch the words that the user is currently learning for the selected level
//        let wordsBeingLearned = storedWords.arrayForLevel(currentLevelSelected)
//        print("Original Init Block. Words being learned count: \(wordsBeingLearned.count)")
//        
//        //NOTE: Limit the number of words to the wordsPerRevisionSetting value
//        let limitedWordsBeingLearned = Array(wordsBeingLearned.shuffled().prefix(wordsPerRevisionSetting))
//        print("Original Init Block. Limited words count: \(limitedWordsBeingLearned.count)")
//        
//        //NOTE: Generate QuizItem objects for each word in wordsBeingLearned
//        _quizItems = limitedWordsBeingLearned.compactMap { wordItemNew in
//            if let fullWord = storedWords.storageForLevel(currentLevelSelected).first(where: { $0.word == wordItemNew.word}) {
//                return QuizItem.generateQuizItem(for: currentLevelSelected, userLanguage: languageCodeForUse, storedWords: storedWords, primaryWord: fullWord)
//            }
//            print("Original Init Block. Failed to generate quiz item for word: \(wordItemNew.word)")
//            return nil
//        }
//        
//        //NOTE: Initialize question statuses as neutral
//            _questionStatuses = State(initialValue: Array(repeating: .neutral, count: wordsPerRevisionSetting))
//        print("Original Init Block. Quiz initialized with \(quizItems.count) items")
//    }
//    
//    
//    func validateAnswer(word: String) {
//        hasAnswered = true
//        selectedAnswer = word
//        
//        let correctAnswer = quizItems[currentQuizIndex].possibleAnswers[quizItems[currentQuizIndex].correctAnswerIndex]
//        let isCorrect = word == correctAnswer
//        
//        selectedAnswerCorrectness = (word, isCorrect)
//        feedbackColor = isCorrect ? .green : .red
//        withAnimation(Animation.easeInOut(duration: 0.5)) {
//            showCircleAnimation = true
//            auraEffectScale = 1.0
//        }
//        
//        //NOTE: Logic for the counters on the QuizSummary Screen
//        if isCorrect {
//            correctAnswerNumber += 1
//        } else {
//            incorrectAnswerNumber += 1
//        }
//        
//        if currentQuizIndex >= 0 && currentQuizIndex < questionStatuses.count {
//            questionStatuses[currentQuizIndex] = isCorrect ? .correct : .incorrect
//            print("Updated questionStatuses at index \(currentQuizIndex) to \(isCorrect ? "correct" : "incorrect").")
//        } else {
//            print("Error: Tried to access questionStatuses at out-of-range index \(currentQuizIndex).")
//        }
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//            withAnimation(Animation.easeInOut(duration: 0.5)) {
//                showCircleAnimation = false
//                auraEffectScale = 0.0
//                feedbackColor = Color.clear
//                selectedAnswerCorrectness = nil
//                
//                if currentQuizIndex < quizItems.count - 1 {
//                    currentQuizIndex += 1
//                    currentVideo = quizItems[currentQuizIndex].videoExample
//                    self.percent += 0.1
//                    if self.percent > 1.0 {
//                        self.percent = 1.0
//                    }
//                    hasAnswered = false
//                } else {
//                    print("Reached the end of the quizItems.")
//                    isQuizFinished = true
//                    finishQuiz()
//                    showQuizSummary = true
//                    
//                }
//                if !isQuizFinished {
//                    resetAndAnimateUIComponents()
//                }
//            }
//            saveCurrentQuizState()
//        }
//        //NOTE: Update the status for the current question
//            questionStatuses[currentQuizIndex] = isCorrect ? .correct : .incorrect
//        print("Updated questionStatuses at index \(currentQuizIndex) to \(isCorrect ? "correct" : "incorrect").")
//        
//        // --- Code for saving Quiz progress ---
//        saveCurrentQuizState()
//        // ---Code for saving Quiz progress ends---
//    }
//    
//    private func finishQuiz() {
//           let finalScore = sessionScore  // Utilizing the computed property for the score
//           let currentDate = Date()
//           storedNewWordItems.shared.quizHistory.saveQuizData(date: currentDate, score: finalScore)
//           storedNewWordItems.shared.quizHistory.saveToPersistentStorage()
//           
//           // Trigger navigation to Summary View
//           self.isQuizFinished = true
//       }
//    private func saveCurrentQuizState() {
//            let state = storedNewWordItems.QuizState(
//                currentQuizIndex: currentQuizIndex,
//                questionStatuses: questionStatuses,
//                correctAnswerCount: correctAnswerNumber,
//                incorrectAnswerCount: incorrectAnswerNumber
//            )
//            do {
//                try storedWords.saveQuizState(state)
//            } catch {
//                print("Could not save quiz state: \(error)")
//            }
//        }
//    
//    func resetAndAnimateUIComponents() {
//        // Reset visibility states
//        showIndicators = false
//        showQuizCard = false
//
//        
//        // Apply animations with a slight delay
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            withAnimation {
//                self.showIndicators = true
//            }
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//            withAnimation {
//                self.showQuizCard = true
//            }
//        }
//    }
//    
//    func resetQuiz() {
//           currentQuizIndex = 0
//           correctAnswerNumber = 0
//           incorrectAnswerNumber = 0
//           isQuizFinished = false
//           questionStatuses = Array(repeating: .neutral, count: quizItems.count)
//       }
//    
//    var sessionScore: Double {
//           let totalQuestions = correctAnswerNumber + incorrectAnswerNumber
//           return totalQuestions > 0 ? (Double(correctAnswerNumber) / Double(totalQuestions)) * 100 : 0.0
//       }
//    
//}
