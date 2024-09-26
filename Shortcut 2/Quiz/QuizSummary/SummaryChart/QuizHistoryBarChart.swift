//
//  QuizHistoryBarChart.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 9/26/24.
//

import SwiftUI
import Charts

struct QuizHistoryBarChart: View {
    let quizHistory: QuizHistory
    
    var body: some View {
        Chart {
            ForEach(quizHistory.recentSessions) { session in
                BarMark(
                    x: .value("Date", formatDate(session.date)),
                    y: .value("Score", session.score)
                )
                .foregroundStyle(Color.blue)
                .cornerRadius(4)
            }
        }
        .chartXAxis {
            AxisMarks(values: .automatic) { _ in
                AxisValueLabel(orientation: .horizontal)
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .frame(height: 200)
        .padding()
    }
    
    private func formatDate(_ date: Date) -> String {
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MM/dd HH:mm"
        return outputFormatter.string(from: date)
    }
}

struct QuizHistoryBarChart_Previews: PreviewProvider {
    static var sampleQuizHistory: QuizHistory {
        var history = QuizHistory()
        let now = Date()
        for i in 0..<10 {
            let date = Calendar.current.date(byAdding: .hour, value: -i, to: now)!
            let score = Double.random(in: 60...100)
            history.saveQuizData(date: date, score: score)
        }
        return history
    }
    
    static var previews: some View {
        QuizHistoryBarChart(quizHistory: sampleQuizHistory)
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Color.gray.opacity(0.1))
            .previewDisplayName("Quiz History Chart")
    }
}
