//
//  QuizViewTest.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 7/1/25.
//

import SwiftUI

struct QuizViewTest: View {
    @AppStorage("currentLearningMode_key") var currentLearningMode: String = "discovery"
    @AppStorage("currentLevelSelected_key") var currentLevelSelected: String = "elementary"
    @AppStorage("nativeLanguageSelectedID_key") var languageCodeForUse: String = "ENUK_transl"
    @AppStorage("wordsPerRevisionSetting_key") var wordsPerRevisionSetting: Int = 30
    
    @State var quizItems: [QuizItem] = []
    @State var currentQuizIndex: Int = 0
    @State var selectedAnswer: String? = nil
    @State var feedbackColor: Color = Color.clear
    @State var percent: CGFloat = 0.0
    let screenHeight = UIScreen.main.bounds.height
    @State var selectedAnswerCorrectness: (word: String, isCorrect: Bool)? = nil
    @State private var currentVideo: URL?
    @State private var showCircleAnimation: Bool = false
    @State private var auraEffectScale: CGFloat = 0.0
    @State private var hasAnswered: Bool = false
    @State var correctAnswerNumber = 0
    @State var incorrectAnswerNumber = 0
    @State private var isQuizFinished: Bool = false
    @State private var showQuizSummary: Bool = false
    @State var questionStatuses: [AnswerStatus] = []
    
    @State var showIndicators = false
    @State var showQuizCard = false
    @State var showAnswerOptions = false
    @State private var isViewLoaded = false
    @State var hasNavigatedAway = false
    
    // --- Code for Saving Quiz Historical Data ---
    var sessionScore: Double {
        let totalQuestions = correctAnswerNumber + incorrectAnswerNumber
        return totalQuestions > 0 ? (Double(correctAnswerNumber) / Double(totalQuestions)) * 100 : 0.0
    }
    @State private var quizHistory = QuizHistory()
    @State private var isQuizAlreadyStarted: Bool = false
    
    //NOTE: Computed property for taking possibleAnswers as a source of the answer options
    var currentPossibleAnswers: [String] {
        if currentQuizIndex < quizItems.count {
            return quizItems[currentQuizIndex].possibleAnswers
        }
        return []
    }
    
    init(storedWords: storedNewWordItems) {
        print("Original Init Block. Initializing quiz")
        print("Original Init Block. Current level selected: \(currentLevelSelected)")
        
        //NOTE: Fetch the words that the user is currently learning for the selected level
        let wordsBeingLearned = storedWords.arrayForLevel(currentLevelSelected)
        print("Original Init Block. Words being learned count: \(wordsBeingLearned.count)")
        
        //NOTE: Limit the number of words to the wordsPerRevisionSetting value
        let limitedWordsBeingLearned = Array(wordsBeingLearned.shuffled().prefix(wordsPerRevisionSetting))
        print("Original Init Block. Limited words count: \(limitedWordsBeingLearned.count)")
        
        //NOTE: Generate QuizItem objects for each word in wordsBeingLearned
        _quizItems = State(initialValue: limitedWordsBeingLearned.compactMap { wordItemNew in
            if let fullWord = storedWords.storageForLevel(currentLevelSelected).first(where: { $0.word == wordItemNew.word}) {
                return QuizItem.generateQuizItem(for: currentLevelSelected, userLanguage: languageCodeForUse, storedWords: storedWords, primaryWord: fullWord)
            }
            print("Original Init Block. Failed to generate quiz item for word: \(wordItemNew.word)")
            return nil
        })
        
        //NOTE: Initialize question statuses as neutral
        _questionStatuses = State(initialValue: Array(repeating: .neutral, count: wordsPerRevisionSetting))
        print("Original Init Block. Quiz initialized with \(quizItems.count) items")
    }
    
    private var indicatorsLayout: (rows: Int, indicatorsPerRow: Int) {
        switch wordsPerRevisionSetting {
        case 10:
            return (1, 10)
        case 20:
            return (2, 10)
        case 30:
            return (2, 15)
        default:
            return (1, min(wordsPerRevisionSetting, 10))
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundColor").ignoresSafeArea()
                
                if isQuizFinished {
                    QuizSummaryView(correctAnswerNumber: $correctAnswerNumber, incorrectAnswerNumber: $incorrectAnswerNumber, isQuizAlreadyStarted: $isQuizAlreadyStarted, isQuizFinished: $isQuizFinished)
                        .opacity(isQuizFinished ? 1 : 0)
                        .animation(.easeIn, value: isQuizFinished)
                } else {
                    if showCircleAnimation {
                        AuraEffect(feedbackColor: feedbackColor)
                            .scaleEffect(auraEffectScale)
                    }
                    
                    VStack(spacing: 0) {
                        // Top section with indicators
                        VStack(spacing: 16) {
                            //NOTE: Generate rows
                            ForEach(0..<indicatorsLayout.rows, id: \.self) { rowIndex in
                                //NOTE: Generate indicators for each row
                                HStack(spacing: 0) {
                                    ForEach(0..<indicatorsLayout.indicatorsPerRow, id: \.self) { indicatorIndex in
                                        let globalIndex = rowIndex * indicatorsLayout.indicatorsPerRow + indicatorIndex
                                        if globalIndex < questionStatuses.count {
                                            Indicator(status: questionStatuses[globalIndex])
                                        }
                                        if indicatorIndex < indicatorsLayout.indicatorsPerRow - 1 {
                                            Spacer()
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                        .padding(.top, screenHeight > 700 ? 32 : 16)
                        .opacity(showIndicators ? 1 : 0)
                        .animation(.easeInOut(duration: 0.5).delay(0.0), value: showIndicators)
                        
                        // Spacer after indicators
                        Spacer().frame(height: screenHeight > 852 ? 48 : (screenHeight > 700 ? 32 : 10))
                        
                        // Card section with fixed height to maintain layout
                        VStack {
                            if currentQuizIndex < quizItems.count {
                                QuizCardVIew2(word: quizItems[currentQuizIndex].quizWord)
                                    .id(quizItems[currentQuizIndex].quizWord)
                                    .layoutPriority(1)
                                    .opacity(showCircleAnimation ? 0 : (showQuizCard ? 1 : 0))
                                    .offset(y: showQuizCard ? 0 : 15)
                                    .animation(.easeInOut(duration: 0.5).delay(0.0), value: showQuizCard)
                            }
                        }
                        .frame(minHeight: 300, maxHeight: 400)
                        
                        // Fixed spacer between card and answer options
                        Spacer().frame(height: 30)
                        
                        //NOTE: Answer options - always at bottom
                        VStack(spacing: 10) {
                            HStack {
                                ForEach(currentPossibleAnswers.prefix(2), id: \.self) { answer in
                                    Button ( action: {
                                        validateAnswer(word: answer)
                                    }) {
                                        AnswerOptionView(answerWord: answer, selectedAnswerCorrectness: $selectedAnswerCorrectness, correctAnswer: quizItems[currentQuizIndex].possibleAnswers[quizItems[currentQuizIndex].correctAnswerIndex])
                                    }
                                    .disabled(hasAnswered)
                                }
                            }
                            HStack {
                                ForEach(currentPossibleAnswers.suffix(2), id: \.self) { answer in
                                    Button ( action: {
                                        validateAnswer(word: answer)
                                    }) {
                                        AnswerOptionView(answerWord: answer, selectedAnswerCorrectness: $selectedAnswerCorrectness, correctAnswer: quizItems[currentQuizIndex].possibleAnswers[quizItems[currentQuizIndex].correctAnswerIndex])
                                    }
                                    .disabled(hasAnswered)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, screenHeight < 700 ? 16 : 24)
                        .opacity(showAnswerOptions ? 1 : 0)
                        .offset(y: showAnswerOptions ? 0 : 15)
                        .animation(.easeInOut(duration: 0.5).delay(0.0), value: showAnswerOptions)
                        
                        // Bottom spacer for safe area
                        Spacer().frame(height: 44)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationTitle(Text ("Quiz"))
        }
        .onAppear {
            print("onAppear. QuizView onAppear called")
            print("onAppear. Current quizItems count: \(quizItems.count)")
            
            // Ensuring questionStatuses properly initialized on view appear
            if questionStatuses.isEmpty {
                questionStatuses = Array(repeating: .neutral, count: quizItems.count)
            }
            print("onAppear. QuizView appearing. Current question statuses count: \(questionStatuses.count)")
            
            // --- Code for saving Quiz progress ---
            if UserDefaults.standard.bool(forKey: "justReset") {
                UserDefaults.standard.set(false, forKey: "justReset")
                questionStatuses = Array(repeating: .neutral, count: quizItems.count)
                print("onAppear. Reset flag found, starting fresh...")
            } else {
                loadQuizState()
                print("onAppear.Loading existing quiz state...")
            }
            print("onAppear. Initialized questionStatuses with \(questionStatuses.count) items.")
            
            // --- Test for saving Quiz historical data ---
            if !isQuizAlreadyStarted {
                let startTime = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let dateKey = dateFormatter.string(from: startTime)
                quizHistory.quizHistoricalData[dateKey] = 0.0
                isQuizAlreadyStarted = true
                
                do {
                    let jsonData = try quizHistory.encodeToJson()
                } catch {
                    print("onAppear. Error encoding quiz history: \(error)")
                }
                print (startTime)
            }
            
            if !hasNavigatedAway {
                resetAndAnimateUIComponents()
            } else {
                hasNavigatedAway = false
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation {
                    self.showAnswerOptions = true
                }
            }
            
            if let firstVideo = quizItems.first?.videoExample {
                currentVideo = firstVideo
                print("Current wordsPerRevisionSetting: \(wordsPerRevisionSetting)")
            }
        }
        .onDisappear {
            hasNavigatedAway = true
        }
    }
    
    // ---Code for saving Quiz progress ---
    func loadQuizState() {
        do {
            if let loadedState = try storedNewWordItems.shared.loadQuizState() {
                self.currentQuizIndex = loadedState.currentQuizIndex
                self.questionStatuses = loadedState.questionStatuses
                
                if self.questionStatuses.isEmpty {
                    self.questionStatuses = Array(repeating: .neutral, count: quizItems.count)
                }
                
                self.correctAnswerNumber = loadedState.correctAnswerCount
                self.incorrectAnswerNumber = loadedState.incorrectAnswerCount
                self.isQuizFinished = loadedState.isQuizFinished
                
                if self.isQuizFinished {
                    self.showQuizSummary = true
                }
            }
        } catch {
            print("Could not load quiz state: \(error)")
            self.questionStatuses = Array(repeating: .neutral, count: quizItems.count)
        }
    }

    //NOTE: Function the holds answer validation logic
    func validateAnswer(word: String) {
        hasAnswered = true
        selectedAnswer = word
        
        let correctAnswer = quizItems[currentQuizIndex].possibleAnswers[quizItems[currentQuizIndex].correctAnswerIndex]
        let isCorrect = word == correctAnswer
        
        selectedAnswerCorrectness = (word, isCorrect)
        feedbackColor = isCorrect ? .green : .red
        withAnimation(Animation.easeInOut(duration: 0.5)) {
            showCircleAnimation = true
            auraEffectScale = 1.0
        }
        
        if isCorrect {
            correctAnswerNumber += 1
        } else {
            incorrectAnswerNumber += 1
        }
        
        if currentQuizIndex >= 0 && currentQuizIndex < questionStatuses.count {
            questionStatuses[currentQuizIndex] = isCorrect ? .correct : .incorrect
            print("Updated questionStatuses at index \(currentQuizIndex) to \(isCorrect ? "correct" : "incorrect").")
        } else {
            print("Error: Tried to access questionStatuses at out-of-range index \(currentQuizIndex).")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            withAnimation(Animation.easeInOut(duration: 0.5)) {
                showCircleAnimation = false
                auraEffectScale = 0.0
                feedbackColor = Color.clear
                selectedAnswerCorrectness = nil
                
                if currentQuizIndex < quizItems.count - 1 {
                    currentQuizIndex += 1
                    currentVideo = quizItems[currentQuizIndex].videoExample
                    self.percent += 0.1
                    if self.percent > 1.0 {
                        self.percent = 1.0
                    }
                    hasAnswered = false
                } else {
                    print("Reached the end of the quizItems.")
                    isQuizFinished = true
                    finishQuiz()
                    showQuizSummary = true
                }
                if !isQuizFinished {
                    resetAndAnimateUIComponents()
                }
            }
            saveCurrentQuizState()
        }
        questionStatuses[currentQuizIndex] = isCorrect ? .correct : .incorrect
        print("Updated questionStatuses at index \(currentQuizIndex) to \(isCorrect ? "correct" : "incorrect").")
    }
    
    func saveCurrentQuizState() {
        let state = storedNewWordItems.QuizState(
            currentQuizIndex: currentQuizIndex,
            questionStatuses: questionStatuses,
            correctAnswerCount: correctAnswerNumber,
            incorrectAnswerCount: incorrectAnswerNumber,
            isQuizFinished: isQuizFinished
        )
        do {
            try storedNewWordItems.shared.saveQuizState(state)
        } catch {
            print("Could not save quiz state: \(error)")
        }
    }
    
    func resetAndAnimateUIComponents() {
        showIndicators = false
        showQuizCard = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation {
                self.showIndicators = true
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation {
                self.showQuizCard = true
            }
        }
    }
    
    private func finishQuiz() {
        let finalScore = sessionScore
        let currentDate = Date()
        storedNewWordItems.shared.quizHistory.saveQuizData(date: currentDate, score: finalScore)
        storedNewWordItems.shared.quizHistory.saveToPersistentStorage()
        self.isQuizFinished = true
    }
    
    private func synchronizeQuestionStatuses() {
        if questionStatuses.count != quizItems.count {
            questionStatuses = Array(repeating: .neutral, count: quizItems.count)
        }
    }
}

struct QuizViewTest_Previews: PreviewProvider {
    static var previews: some View {
        QuizViewTest(storedWords: storedNewWordItems())
            .onAppear {
                // For preview purposes, show the UI elements immediately
                DispatchQueue.main.async {
                    if let preview = UIApplication.shared.windows.first?.rootViewController?.view.subviews.first {
                        // This is a hack to trigger the animations in preview
                        // You might want to create mock data instead
                    }
                }
            }
    }
}

//#Preview {
//    QuizViewTest(storedWords: storedNewWordItems())
//}
