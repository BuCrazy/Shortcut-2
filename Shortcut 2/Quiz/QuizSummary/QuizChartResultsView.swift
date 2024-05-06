//
//  QuizChartResultsView.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 5/6/24.
//

import SwiftUI

struct QuizChartResultsView: View {
    var quizHistory: QuizHistory
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 16) {
            VStack(alignment: .leading, spacing: 16) {
                VStack (alignment: .leading, spacing: 4) {
                    Text("All Time Average Score")
                        .font(.system(size: 13))
                        .fontWeight(.semibold)
                        .foregroundStyle(.blue)
                    
                    Text("\(quizHistory.totalAverage, specifier: "%.1f")%")
                        .font(.system(size: 24))
                        .bold()
                }
            }
            Rectangle()
                .fill(.white).opacity(0.3)
                .frame(width: 0.5, height: 49)
            Text("*The chart is shown \nthe last 10 Quiz Sessions")
                .font(.system(size: 12))
                .foregroundStyle(Color("secondaryCardColor"))
        }
    }
}

struct QuizChartResultsView_Previews: PreviewProvider {
    static var quizHistory = QuizHistory()
    static var previews: some View {
        QuizChartResultsView(quizHistory: quizHistory)
    }
}
