//
//  QuizDraft.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 8/30/24.
//

import SwiftUI


struct QuizDraft: View {
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
    
    // --- Code for Saving Quiz Historical Data ends ---
    
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
                
                //NOTE: Initial logic for switching views
                if isQuizFinished {
                  
                    QuizSummaryView(correctAnswerNumber: $correctAnswerNumber, incorrectAnswerNumber: $incorrectAnswerNumber, isQuizAlreadyStarted: $isQuizAlreadyStarted)
                           .opacity(isQuizFinished ? 1 : 0)
                           .animation(.easeIn, value: isQuizFinished)
                } else {
                    if showCircleAnimation {
                        AuraEffect(feedbackColor: feedbackColor)
                            .scaleEffect(auraEffectScale)
                    }
                    VStack {
                        if !showCircleAnimation {
                            
                        //NOTE: Quiz Card + Indicator
                        VStack {
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
                    //      .offset(y: showIndicators ? 0 : 25)
                            .animation(.easeInOut(duration: 0.5).delay(0.0), value: showIndicators)
                                
                        //NOTE: Quiz Card
                        Spacer().frame(height: screenHeight > 852 ? 48 : (screenHeight > 700 ? 32 : 10))
                        VStack {
                            if currentQuizIndex < quizItems.count {
                                QuizCardView(word: quizItems[currentQuizIndex].quizWord, question: quizItems[currentQuizIndex].questionText, video: $currentVideo/*, shouldStopVideo: $shouldStopVideo*/)
                                    .id(quizItems[currentQuizIndex].quizWord)
                            }
                        }
                        .opacity(showQuizCard ? 1 : 0)
                        .offset(y: showQuizCard ? 0 : 15)
                        .animation(.easeInOut(duration: 0.5).delay(0.0), value: showQuizCard)
                        }
                      }
                        
                    //NOTE: Answer options
                    VStack(spacing: 10) {
                        Spacer()
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
            // --- Code for saving Quiz progress ends---
            // --- Test for saving Quiz historical data ---
            if !isQuizAlreadyStarted {
                
                let startTime = Date()
                // Format the start date as a string
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let dateKey = dateFormatter.string(from: startTime)
                // Initialize the quiz session with the start date
                quizHistory.quizHistoricalData[dateKey] = 0.0 // Use nil or a placeholder score
                isQuizAlreadyStarted = true // Set this flag to true to indicate the quiz has started
                
                do {
                    let jsonData = try quizHistory.encodeToJson()
                    // Persist jsonData to a file
                } catch {
                    print("onAppear. Error encoding quiz history: \(error)")
                }
                print (startTime)
            }
            // --- Test for saving Quiz historical data ---
            
            
            if !hasNavigatedAway {
                
                //NOTE: Only reset and animate if the user did not navigate away
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
          //      shouldStopVideo = false
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
                
                // Ensure questionStatuses is not empty
                if self.questionStatuses.isEmpty {
                    self.questionStatuses = Array(repeating: .neutral, count: quizItems.count)
                }
                
                //test
                self.correctAnswerNumber = loadedState.correctAnswerCount
                self.incorrectAnswerNumber = loadedState.incorrectAnswerCount
                // Load any other necessary state components
            }
        } catch {
            print("Could not load quiz state: \(error)")
            // Initialize questionStatuses if loading fails
            self.questionStatuses = Array(repeating: .neutral, count: quizItems.count)
        }
    }
    // ---Code for saving Quiz progress ends ---

    //NOTE: Function the holds ansver validation logic
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
        
        //NOTE: Logic for the counters on the QuizSummary Screen
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
        //NOTE: Update the status for the current question
            questionStatuses[currentQuizIndex] = isCorrect ? .correct : .incorrect
        print("Updated questionStatuses at index \(currentQuizIndex) to \(isCorrect ? "correct" : "incorrect").")
        
        // --- Code for saving Quiz progress ---
        saveCurrentQuizState()
        // ---Code for saving Quiz progress ends---
    }
    
    // ---Code for saving Quiz progress ---
    func saveCurrentQuizState() {
        let state = storedNewWordItems.QuizState(
            currentQuizIndex: currentQuizIndex,
            questionStatuses: questionStatuses,
            //test
            correctAnswerCount: correctAnswerNumber,
            incorrectAnswerCount: incorrectAnswerNumber
        )
        do {
            try storedNewWordItems.shared.saveQuizState(state)
        } catch {
            print("Could not save quiz state: \(error)")
        }
    }
    
    // ---Code for saving Quiz progress ends---
    
    
    func resetAndAnimateUIComponents() {
        // Reset visibility states
        showIndicators = false
        showQuizCard = false

        
        // Apply animations with a slight delay
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
    
    // Code for updating historical chart with current quiz
    private func finishQuiz() {
           let finalScore = sessionScore  // Utilizing the computed property for the score
           let currentDate = Date()
           storedNewWordItems.shared.quizHistory.saveQuizData(date: currentDate, score: finalScore)
           storedNewWordItems.shared.quizHistory.saveToPersistentStorage()
           
           // Trigger navigation to Summary View
           self.isQuizFinished = true
       }
    // Code for updating historical chart with current quiz ends
    
    
    //Ensuring that count of questionStatuses is always matches the count of quizItems
    private func synchronizeQuestionStatuses() {
        if questionStatuses.count != quizItems.count {
            questionStatuses = Array(repeating: .neutral, count: quizItems.count)
        }
    }
}

struct QuizDraft_Previews: PreviewProvider {
    static var previews: some View {
        QuizView(storedWords: storedNewWordItems())
    }
}
