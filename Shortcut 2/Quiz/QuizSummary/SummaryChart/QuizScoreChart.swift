//
//  QuizScoreChart.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 4/29/24.
//

import SwiftUI
import Charts

struct QuizScoreChart: View {
    let quizHistory: QuizHistory
    let quizChartGradient = LinearGradient (
        stops: [
        Gradient.Stop(color: Color(red: 0.17, green: 0.54, blue: 1), location: 0.00),
        Gradient.Stop(color: Color(red: 0.16, green: 0.49, blue: 1).opacity(0), location: 1.00),
        ],
        startPoint: UnitPoint(x: 0.5, y: 0),
        endPoint: UnitPoint(x: 0.5, y: 1)
    )
    
    var body: some View {
        let scoreEntries = quizHistory.quizHistoricalData.compactMap { (key, value) -> QuizScoreEntry? in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            guard let date = dateFormatter.date(from: key) else { return nil }
            if value > 100 {
                    print("Anomalous data point: \(key) has score \(value)")
                }
            return QuizScoreEntry(date: date, score: value)
        }.sorted(by: { $0.date < $1.date })
        
        ZStack {
            Chart {
                ForEach(scoreEntries) { entry in
                    AreaMark(
                        x: .value("Date", entry.date, unit: .minute),
                        y: .value("Score", entry.score)
                    )
                    .clipShape(Rectangle())
                    .foregroundStyle(.blue)
                    .opacity(0.5)
                   
               
                    
                    LineMark(
                        x: .value("Date", entry.date, unit: .minute),
                        y: .value("Score", entry.score * 1.01)
                    )
                    .shadow(radius: 2, x: 0, y: 2)
                }
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: Calendar.Component.minute, count: 30)) { value in
                    AxisGridLine()
                    AxisTick()
                }
            }
            .chartYAxis {
           AxisMarks(preset: .extended)
              
            }
        }
        .onAppear {
            print(" A dictionary of the quiz historical results: \(quizHistory.quizHistoricalData)")
        }
    }
}

struct QuizScoreChart_Previews: PreviewProvider {
    static var previews: some View {
        let sampleQuizHistory = QuizHistory()
        
        // Use the sampleQuizHistory to preview QuizScoreChart
        QuizScoreChart(quizHistory: sampleQuizHistory)
            .padding()
    }
}

struct QuizScoreEntry: Identifiable {
    let id = UUID()
    let date: Date
    let score: Double
}
