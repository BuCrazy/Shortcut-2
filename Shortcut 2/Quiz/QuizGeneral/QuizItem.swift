//
//  QuizItem.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 2/28/24.
//

import Foundation

struct QuizItem: Hashable, Equatable {
    var quizWord: String
    var questionText: String
    var possibleAnswers: [String]
    var correctAnswerIndex: Int
    var videoExample: URL
    
    init(quizWord: String, questionText: String, possibleAnswers: [String], correctAnswerIndex: Int, videoExample: URL) {
        self.quizWord = quizWord
        self.questionText = questionText
        self.possibleAnswers = possibleAnswers
        self.correctAnswerIndex = correctAnswerIndex
        self.videoExample = videoExample
    }
    
    static func generateQuizItem(for level: String, userLanguage: String, storedWords: storedNewWordItems, primaryWord: WordItemStruct) -> QuizItem? {
        
        //NOTE: Array for storing possible answers
        var answers = [String]()
        
        //NOTE: Generate Translation for the primary word
        let correctTranslation = primaryWord.translationForLanguage(userLanguage)
        answers.append(correctTranslation)
        
        //NOTE: Fetch translations for 3 other incorrect answer options and check for duplications
        while answers.count < 4 {
            if let randomWord = storedWords.storageForLevel(level).randomElement(), randomWord.word != primaryWord.word {
                let translation = randomWord.translationForLanguage(userLanguage)
                if !answers.contains(translation) {
                    answers.append(translation)
                }
            }
        }
        
        //NOTE: Randomize the order of answers and find the index of the correct answer
        answers.shuffle()
        let correctAnswerIndex = answers.firstIndex(of: correctTranslation) ?? 0
        
        
        //NOTE: Determine Video URL
        guard let videoURL = URL(string: primaryWord.video) else { return nil }
        
        //NOTE: Formulate QuizItem
        return QuizItem(
            quizWord: primaryWord.word,
            questionText: "What is the correct translation for '\(primaryWord.word)'?",
            possibleAnswers: answers,
            correctAnswerIndex: correctAnswerIndex,
            videoExample: videoURL
        )
    }
    
}
