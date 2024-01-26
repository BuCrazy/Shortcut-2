//
//  QuizItem.swift
//  Shortcut 2
//
//  Created by Pavlo Bilashchuk on 1/15/24.
//

import Foundation
import SwiftUI

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
    
    static func generateQuizItem(for level: String, userLanguage: String, storedWords: storedNewWordItems) -> QuizItem? {
        //NOTE: Select a Quiz Word
        guard let selectedWord = storedWords.arrayForLevel(level).randomElement() else { return nil }
        
        //NOTE: Fetch Full Word Details
        guard let fullWordDetails = storedWords.storageForLevel(level).first(where: { $0.id == selectedWord.id }) else { return nil }
        
        
        //NOTE: Generate Translations for Answers
        var answers = [String]()
        answers.append(fullWordDetails.translationForLanguage(userLanguage))
        
        while answers.count < 4 {
            if let randomWord = storedWords.arrayForLevel(level).randomElement(), randomWord.id != selectedWord.id {
                let translation = storedWords.storageForLevel(level).first(where: { $0.id == randomWord.id })?.translationForLanguage(userLanguage) ?? ""
                if !answers.contains(translation) {
                    answers.append(translation)
                }
            }
        }
        
        let correctAnswerIndex = Int.random(in: 0..<answers.count)
        answers.shuffle()
        
        //NOTE: Determine Viedo URL
        guard let videoURL = URL(string: fullWordDetails.video) else {return nil}
        
        //NOTE: Formulate QuizItem
        return QuizItem(
            quizWord: fullWordDetails.word,
            questionText: "What is the correct translation for '\(fullWordDetails.word)'?",
            possibleAnswers: answers,
            correctAnswerIndex: correctAnswerIndex,
            videoExample: videoURL)
        
    }
    
    

}


