//
//  HistoricalDataView.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 5/6/24.
//

import SwiftUI

struct HistoricalDataView: View {
    var quizHistory: QuizHistory
    
    var body: some View {
        HStack {
            VStack (alignment: .leading, spacing: 16) {
                Text("Historical Data")
                    .font(.system(size: 15))
                    .bold()
                    .padding(.top, 16)
                    .padding(.leading, 16)
                
                
                QuizChartResultsView(quizHistory: quizHistory)
                    .padding(.horizontal, 16)
                QuizHistoryBarChart(quizHistory: quizHistory)
                    .frame(height: 216)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
               
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color("mainCardBG"))
        .cornerRadius(10)
    }
}

struct HistoricalDataView_Previews: PreviewProvider {
    static var sampleQuizHistory: QuizHistory {
        var history = QuizHistory()
        let now = Date()
        for i in 0..<10 {
            let date = Calendar.current.date(byAdding: .day, value: -i, to: now)!
            let score = Double.random(in: 60...100)
            history.saveQuizData(date: date, score: score)
        }
        return history
    }
    
    static var previews: some View {
        Group {
            HistoricalDataView(quizHistory: sampleQuizHistory)
                .previewDisplayName("With Sample Data")
            
            HistoricalDataView(quizHistory: QuizHistory())
                .previewDisplayName("Empty History")
        }
        .previewLayout(.sizeThatFits)
       // .padding()
        .background(Color.gray.opacity(0.1))
    }
}
//struct HistoricalDataView_Previews: PreviewProvider {
//    static var quizHistory = QuizHistory()
//    static var previews: some View {
//        HistoricalDataView(quizHistory: quizHistory)
//    }
//}
