//
//  QuizView.swift
//  Shortcut 2
//
//  Created by Pavlo Bilashchuk on 1/15/24.
//

import SwiftUI

struct QuizView: View {
    @AppStorage("currentLearningMode_key") var currentLearningMode: String = "discovery"
    @AppStorage("currentLevelSelected_key") var currentLevelSelected: String = "elementary"
    @AppStorage("nativeLanguageSelectedID_key") var languageCodeForUse: String = "ENUK_transl"
    
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
    
    //NOTE: Computed property for taking possibleAnswers as a source of the answer options
    var currentPossibleAnswers: [String] {
        if currentQuizIndex < quizItems.count {
            return quizItems[currentQuizIndex].possibleAnswers
        }
        return []
    }
    
   // var wordData: [WordItemStruct]
    
    init(wordData: [WordItemStruct]) {
        _quizItems = State(initialValue: wordData.shuffled().compactMap { wordItem in
            QuizItem.generateQuizItem(for: currentLevelSelected, userLanguage: languageCodeForUse, storedWords: storedNewWordItems())
        })
        print ("printing wordData \(wordData)")
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundColor").ignoresSafeArea()
                
                //NOTE: Initial logic for switching views
                if isQuizFinished {
                    SwiperScreen()
                } else {
                    if showCircleAnimation {
                        AuraEffect(feedbackColor: feedbackColor)
                            .scaleEffect(auraEffectScale)
                    }
                    VStack {
                        if !showCircleAnimation {
                            VStack {
                                //NOTE: Quiz Card
                                Spacer().frame(height: screenHeight > 700 ? 100 : 10)
                                if currentQuizIndex < quizItems.count {
                                    QuizCardView(word: quizItems[currentQuizIndex].quizWord, question: quizItems[currentQuizIndex].questionText, video: $currentVideo)
                                        .id(quizItems[currentQuizIndex].quizWord)
                                }
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
                        
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationTitle(Text ("Quiz"))
        }
    }
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
                    isQuizFinished = true
                    showQuizSummary = true
                }
            }
        }
        
    }
}

//#Preview {
//    QuizView()
//}


struct QuizView_Previews: PreviewProvider {
    // Mock data that resembles the structure of your WordItemStruct
    static let mockWordData: [WordItemStruct] = [
        WordItemStruct(id: 1, position_now: 0, pos: "Noun", word: "Example", phonetics: "/ɪɡˈzæmpəl/", definition: "A thing characteristic of its kind or illustrating a general rule.", collocations: "Good/bad example", sentence: "This is a sentence using the word 'example'.", video: "example_video_url", movie: "Example Movie", movie_quote: "Famous quote from Example Movie", ukranian: "приклад", russian: "пример", bulgarian: "пример", chinese: "例子", czech: "příklad", danish: "eksempel", dutch: "voorbeeld", estonian: "näide", finnish: "esimerkki", french: "exemple", german: "Beispiel", greek: "παράδειγμα", hungarian: "példa", indonesian: "contoh", italian: "esempio", japanese: "例", korean: "예", latvian: "piemērs", lithuanian: "pavyzdys", norwegian: "eksempel", polish: "przykład", portuguese: "exemplo", romanian: "exemplu", slovak: "príklad", slovenian: "primer", spanish: "ejemplo", swedish: "exempel", turkish: "örnek"), WordItemStruct(id: 2, position_now: 1, pos: "Noun", word: "Example2", phonetics: "/ɪɡˈzæmpəl/", definition: "A thing characteristic of its kind or illustrating a general rule.", collocations: "Good/bad example", sentence: "This is a sentence using the word 'example'.", video: "example_video_url", movie: "Example Movie", movie_quote: "Famous quote from Example Movie", ukranian: "приклад", russian: "пример", bulgarian: "пример", chinese: "例子", czech: "příklad", danish: "eksempel", dutch: "voorbeeld", estonian: "näide", finnish: "esimerkki", french: "exemple", german: "Beispiel", greek: "παράδειγμα", hungarian: "példa", indonesian: "contoh", italian: "esempio", japanese: "例", korean: "예", latvian: "piemērs", lithuanian: "pavyzdys", norwegian: "eksempel", polish: "przykład", portuguese: "exemplo", romanian: "exemplu", slovak: "príklad", slovenian: "primer", spanish: "ejemplo", swedish: "exempel", turkish: "örnek"),
            WordItemStruct(id: 3, position_now: 2, pos: "Noun", word: "Example3", phonetics: "/ɪɡˈzæmpəl/", definition: "A thing characteristic of its kind or illustrating a general rule.", collocations: "Good/bad example", sentence: "This is a sentence using the word 'example'.", video: "example_video_url", movie: "Example Movie", movie_quote: "Famous quote from Example Movie", ukranian: "приклад", russian: "пример", bulgarian: "пример", chinese: "例子", czech: "příklad", danish: "eksempel", dutch: "voorbeeld", estonian: "näide", finnish: "esimerkki", french: "exemple", german: "Beispiel", greek: "παράδειγμα", hungarian: "példa", indonesian: "contoh", italian: "esempio", japanese: "例", korean: "예", latvian: "piemērs", lithuanian: "pavyzdys", norwegian: "eksempel", polish: "przykład", portuguese: "exemplo", romanian: "exemplu", slovak: "príklad", slovenian: "primer", spanish: "ejemplo", swedish: "exempel", turkish: "örnek"),
            WordItemStruct(id: 4, position_now: 3, pos: "Noun", word: "Example4", phonetics: "/ɪɡˈzæmpəl/", definition: "A thing characteristic of its kind or illustrating a general rule.", collocations: "Good/bad example", sentence: "This is a sentence using the word 'example'.", video: "example_video_url", movie: "Example Movie", movie_quote: "Famous quote from Example Movie", ukranian: "приклад", russian: "пример", bulgarian: "пример", chinese: "例子", czech: "příklad", danish: "eksempel", dutch: "voorbeeld", estonian: "näide", finnish: "esimerkki", french: "exemple", german: "Beispiel", greek: "παράδειγμα", hungarian: "példa", indonesian: "contoh", italian: "esempio", japanese: "例", korean: "예", latvian: "piemērs", lithuanian: "pavyzdys", norwegian: "eksempel", polish: "przykład", portuguese: "exemplo", romanian: "exemplu", slovak: "príklad", slovenian: "primer", spanish: "ejemplo", swedish: "exempel", turkish: "örnek")
        // Add more WordItemStruct instances as needed
    ]

    static var previews: some View {
        // Provide the mock data to the QuizView initializer
        QuizView(wordData: mockWordData)
    }
}

/*  VStack {
 Button {
     currentLearningMode = "discovery"
 } label: {
     Text("Continue to Discovery")
 }
}*/
