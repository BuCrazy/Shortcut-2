//
//  QuizSummaryView.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 2/23/24.
//

import SwiftUI

struct QuizSummaryView: View {
    @State var feedbackColor: Color = Color.clear
    @Binding var correctAnswerNumber: Int
    @Binding var incorrectAnswerNumber: Int
    @State private var navigateToSwipePractice: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack {
                    BCircleAnimation(feedbackColor: feedbackColor)
                        .blendMode(.screen)
                        .blur(radius: 40)
                    Spacer()
                   SummaryMessage()
                        .padding(.bottom, 16)
                    
                   BottomPart(correctAnswerNumber: $correctAnswerNumber, incorrectAnswerNumber: $incorrectAnswerNumber)
                        .frame(maxHeight: 362)
                }
            }
            .navigationTitle(Text ("Quiz Summary"))
        }
    }
}

struct QuizSummary_Previews: PreviewProvider {

    
    @State static var correctAnswerNumber: Int = 3
    @State static var incorrectAnswerNumber: Int = 7
    static var previews: some View {
        QuizSummaryView(
            correctAnswerNumber: $correctAnswerNumber,
            incorrectAnswerNumber: $incorrectAnswerNumber)
    }
}
