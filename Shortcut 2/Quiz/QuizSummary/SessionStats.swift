//
//  SessionStats.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 5/6/24.
//

import SwiftUI

struct SessionStats: View {
    @Binding var correctAnswerNumber: Int
    @Binding var incorrectAnswerNumber: Int
    var sessionScore: Double
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Session Stats")
                    .font(.system(size: 15))
                    .bold()
                    .padding(.top, 16)
                    .padding(.leading, 16)
                
                HStack(spacing: 16) {
                    CorrectAnswersNumber(correctAnswerNumber: $correctAnswerNumber)
                    IncorrectAnswersNumber(incorrectAnswerNumber: $incorrectAnswerNumber)
                    SessionScoreView(correctAnswerNumber: $correctAnswerNumber, incorrectAnswerNumber: $incorrectAnswerNumber, sessionScore: sessionScore)
                }
                .padding(16)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color("mainCardBG"))
        .cornerRadius(10)
    }
}

struct SessionStats_Previews: PreviewProvider {
    @State static var correctAnswerNumber: Int = 3
    @State static var incorrectAnswerNumber: Int = 7
    static var previews: some View {
        SessionStats(correctAnswerNumber: $correctAnswerNumber, incorrectAnswerNumber: $incorrectAnswerNumber, sessionScore: 42.1)
    }
}
