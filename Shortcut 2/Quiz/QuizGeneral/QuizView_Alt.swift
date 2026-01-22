//
//  QuizView_Alt.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 9/16/25.
//

import SwiftUI
import AVFoundation



extension LayoutSize {
    var bottomCardSpacing: CGFloat {
            switch self {
            case .compact:
                return 32
            case .standard:
                return 72
            case .spacious:
                return 98
            }
        }
    
        var topCardSpacing: CGFloat {
            switch self {
            case .compact:
                return 32
            case .standard:
                return 72
            case .spacious:
                return 80
            }
        }
    
        var cardHeight: CGFloat {
            switch self {
            case .compact:
                return 290 //310 previous value
            case .standard:
                return 335
            case .spacious:
                return 380
            }
        }
    
    var progrressIndicatorTopSpacing: CGFloat {
        switch self {
        case .compact:
            return 16
        case .standard:
            return 20
        case .spacious:
            return 32
        }
    }
}

struct QuizView_Alt: View {
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
    let deviceSize = LayoutSize.current() //TEST Oct 19 (delete this to get back)
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
    
    var correctHaptic = SuccessHaptics()
    var incorrectHaptic = FailHaptics()
    @State private var audioPlayer: AVAudioPlayer?
    
    @Binding var currentView: DiscoveryDesctination?
    
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
    
    init(storedWords: storedNewWordItems, currentView: Binding<DiscoveryDesctination?>) {
        self._currentView = currentView
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
//    var quizCardxAnswerOptionsSpacong: Int {
//        switch iPhoneVerticalSize
//    }
    
    
    
    var body: some View {
        ZStack(alignment: .top) {
            Color("BackgroundColor").ignoresSafeArea()
            
            AuraEffect(feedbackColor: feedbackColor)
                    .scaleEffect(auraEffectScale)
                    .opacity(showCircleAnimation ? 1 : 0) // Control visibility with opacity
                    .animation(.easeInOut(duration: 0.3), value: showCircleAnimation)
                    .onChange(of: showCircleAnimation) {oldValue, newValue in
                        if newValue && feedbackColor != .clear {
                            if feedbackColor == .green {
                                playSound(filename: "CorrectSound", fileExtension: "mp3")
                                correctHaptic.playCustomHapticPatter()
                            } else {
                                if feedbackColor == .red {
                                    playSound(filename: "IncorrectSound", fileExtension: "mp3")
                                    incorrectHaptic.playCustomHapticPatter()

                                }
                            }
                        }
                        
                    }
            
            //General VStack
            VStack {
                Spacer().frame(height: 20)
                
               // View Title + Indicator
                VStack(alignment: .leading) {
                    Text("Quiz")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color("Textprimary"))
                        .multilineTextAlignment(.leading)
                    
                    Spacer().frame(height: deviceSize.progrressIndicatorTopSpacing)
                    
                    //Progress Indicator
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
                    }
                  //  .padding(.top, screenHeight > 700 ? 32 : 16)
                    .opacity(showIndicators ? 1 : 0)
                    .animation(.easeInOut(duration: 0.5).delay(0.0), value: showIndicators)
                }
                .padding(.horizontal, 16)
               // Spacer().frame(height: screenHeight > 848 ? 64 : (screenHeight > 650 ? 24 : 10))
                Spacer().frame(height: deviceSize.topCardSpacing)
             
                
                //NOTE: Quiz Card
                VStack {
                    if currentQuizIndex < quizItems.count {
                        QuizCardVIew2(word: quizItems[currentQuizIndex].quizWord)
                        .id(quizItems[currentQuizIndex].quizWord)
                        .layoutPriority(1)
                    }
                }
                .opacity(showQuizCard ? 1 : 0)
                .offset(y: showQuizCard ? 0 : 20)
                .animation(.easeInOut(duration: 0.3), value: showQuizCard)
                
              // Spacer().frame(height: screenHeight > 848 ? 64 : (screenHeight > 650 ? 16 : 10))
                Spacer().frame(height: deviceSize.bottomCardSpacing)
                
                //NOTE: Answer Options
                VStack(spacing: 10) {
                    
                    //First Answer Row
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
                    
                    //Second Answer Row
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
                .opacity(showAnswerOptions ? 1 : 0)
                .offset(y: showAnswerOptions ? 0 : 15)
                .animation(.easeInOut(duration: 0.3).delay(0.0), value: showAnswerOptions)
                
                Spacer().frame(height: 44)
            }
            
        }
        .onAppear {
//            print("onAppear. QuizView onAppear called")
//            print("onAppear. Current quizItems count: \(quizItems.count)")
            
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
            
            //TEST September 25. Saving Quiz state right away
            saveCurrentQuizState()
            
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
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                        isLoading = false
//                    }
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
                self.isQuizFinished = loadedState.isQuizFinished //test Oct 14 2024
                // Load any other necessary state components
                
                // If the quiz is finished, immediately show the summary, test Oct 14 2024
                if self.isQuizFinished {
                    self.showQuizSummary = true
                }
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
        
        //TEST October 6 (Delete withanimation block to get back)
     //   withAnimation(Animation.easeInOut(duration: 0.3)) {
                   showQuizCard = false
       //     }

        
        //TEST October 6 (Delete Dispatch Quue to get back)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {

          //  withAnimation(Animation.easeInOut(duration: 0.3)) {
                showCircleAnimation = true
                auraEffectScale = 1.0
           // }
            
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.3) {
            withAnimation(Animation.easeInOut(duration: 0.3)) {
                showCircleAnimation = false
                auraEffectScale = 0.0
                feedbackColor = Color.clear
                selectedAnswerCorrectness = nil
            }
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
                    
                    withAnimation(.easeInOut(duration: 0.3)) { //TEST September 2  (delete this  to get back)
                        currentView = .quizSummary(correctAnswers: correctAnswerNumber, incorrectAnswers: incorrectAnswerNumber)
                    }
                }
                if !isQuizFinished {
                    resetAndAnimateUIComponents()
                }
           // }
            saveCurrentQuizState()
        }
        
        //NOTE: Update the status for the current question
            questionStatuses[currentQuizIndex] = isCorrect ? .correct : .incorrect
        print("Updated questionStatuses at index \(currentQuizIndex) to \(isCorrect ? "correct" : "incorrect").")

    }
    
    // ---Code for saving Quiz progress ---
    func saveCurrentQuizState() {
        let state = storedNewWordItems.QuizState(
            currentQuizIndex: currentQuizIndex,
            questionStatuses: questionStatuses,
            //test
            correctAnswerCount: correctAnswerNumber,
            incorrectAnswerCount: incorrectAnswerNumber,
            isQuizFinished: isQuizFinished //test Oct 14 2024
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
      //  showQuizCard = false //TEST October 6 (uncommit to get back)

        
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
    
    func playSound(filename: String, fileExtension: String) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: fileExtension) else { return }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error)")
        }
    }
    
}

#Preview {
    // Create a mock storedNewWordItems instance for preview
        let mockStoredWords = storedNewWordItems()
        
        // Add some sample words to elementary level for testing
        mockStoredWords.elementaryBeingLearned = [
            wordItemNew(id: 1, position_now: 1, word: "hello", dateAdded: "2024-01-01 10:00:00", timesReviewed: 0, consecutiveCorrectRecalls: 0, progress: 0),
            wordItemNew(id: 2, position_now: 2, word: "world", dateAdded: "2024-01-01 11:00:00", timesReviewed: 0, consecutiveCorrectRecalls: 0, progress: 0),
            wordItemNew(id: 3, position_now: 3, word: "test", dateAdded: "2024-01-01 12:00:00", timesReviewed: 0, consecutiveCorrectRecalls: 0, progress: 0)
        ]
        
        return QuizView_Alt(storedWords: mockStoredWords, currentView: .constant(nil))

}




//enum layoutSize { //TEST Oct 19 (delete this to get back)
//case compact  // SE, mini (< 700pt)
//case standard   // Regular iPhones (700-900pt)
//case spacious   // Plus/Max models (> 900pt)
//
//    var bottomCardSpacing: CGFloat {
//        switch self {
//        case .compact:
//            return 32
//        case .standard:
//            return 72
//        case .spacious:
//            return 128
//        }
//    }
//
//    var topCardSpacing: CGFloat {
//        switch self {
//        case .compact:
//            return 32
//        case .standard:
//            return 72
//        case .spacious:
//            return 80
//        }
//    }
//
//    var cardHeight: CGFloat {
//        switch self {
//        case .compact:
//            return 310
//        case .standard:
//            return 335
//        case .spacious:
//            return 380
//        }
//    }
//
//    static func current() -> layoutSize {
//        let height = UIScreen.main.bounds.height
//
//        switch height {
//        case ...700:
//            return .compact
//        case 701...900:
//            return .standard
//        default:
//            return .spacious
//        }
//    }
//}
