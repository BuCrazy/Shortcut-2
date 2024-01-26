//
//  AnswerOptionView.swift
//  Shortcut 2
//
//  Created by Pavlo Bilashchuk on 1/15/24.
//

import SwiftUI

struct AnswerOptionView: View {
    @State var answerWord: String
    @Binding var selectedAnswerCorrectness: (word: String, isCorrect: Bool)?
    var correctAnswer: String
    var borderColor: Color {
        withAnimation() {
            if let selectedInfo = selectedAnswerCorrectness {
                if answerWord == selectedInfo.word {
                    return selectedInfo.isCorrect ? .green : .red
                } else if !selectedInfo.isCorrect && answerWord == correctAnswer {
                    return .green
                }
            }
            return Color.clear
        }
    }
    
    var body: some View {
        HStack{
            Text(answerWord)
                .foregroundColor(.white)
                .font(Font.custom("Avenir", size: 16))
                .fontWeight(.medium)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(Color("mainCardBG"))
        .cornerRadius(48)
        .overlay(
            RoundedRectangle(cornerRadius: 48)
                .stroke(borderColor, lineWidth: 1)
        )
    }
}

#Preview {
    AnswerOptionView(answerWord: "tesla", selectedAnswerCorrectness: .constant(("tesla", true)), correctAnswer: "tesla")
}
