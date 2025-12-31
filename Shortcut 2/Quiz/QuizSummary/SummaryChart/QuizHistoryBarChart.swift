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
               //     x: .value("Date", formatDate(session.date)), // TEST Dec 8 (uncommit to get back)
                    x: .value("Date", session.date, unit: .hour), // TEST Dec 8 (delete to get back)
                    y: .value("Score", session.score)
                )
                .foregroundStyle(Color.blue)
                .cornerRadius(4)
                .annotation(position: .bottom, alignment: .center, spacing: 4) {
                    Text(formatDateForLabel(session.date))
                        .font(.system(size: 10)).opacity(0.5)
                }
            }
        }
        .chartYScale(domain: 0...100)
        .chartXAxis(.hidden)
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .frame(height: 200)
        
//        .chartXAxis { // TEST Dec 8 (delete to get back)
//            AxisMarks(values: .stride(by: .hour, count: 1)) { value in
//                if let date = value.as(Date.self) {
////AxisValueLabel(formatDateForLabel(date))
//                    AxisValueLabel {
//                        Text(formatDateForLabel(date))
//                            .multilineTextAlignment(.center)
//                    }
////AxisGridLine()
//                   // AxisTick()
//                }
//            }
//        }
    }
    

    
    private func formatDateForLabel(_ date: Date) -> String {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MM/dd"  // Simplified format for labels
            return outputFormatter.string(from: date)
        }
    
    private func formatDate(_ date: Date) -> String {
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MM/dd" // TEST Dec 8 (return HH:mm to get back)
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
