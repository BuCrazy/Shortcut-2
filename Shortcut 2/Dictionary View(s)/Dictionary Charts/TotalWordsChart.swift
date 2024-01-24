//
//  TotalWordsChart.swift
//  Shortcut 2
//
//  Created by Pavlo Bilashchuk on 12/6/23.
//

import SwiftUI
import Charts

struct TotalWords: Identifiable {
    var id = UUID().uuidString
    var day: Date
    var wordsAdded: Double
    var animate: Bool = false
}

struct TotalWordsChart: View {
    @Binding var dataSample: [TotalWords]
    @State private var animatedDataSample: [TotalWords] = []
    let chartGradientArea = LinearGradient(
        stops: [
            Gradient.Stop(color: Color(red: 1, green: 0.6, blue: 0), location: 0.00),
            Gradient.Stop(color: Color(red: 1, green: 0.6, blue: 0).opacity(0.18), location: 0.65),
            Gradient.Stop(color: Color(red: 1, green: 0.6, blue: 0).opacity(0), location: 1.00),
        ],
        startPoint: UnitPoint(x: 0.5, y: -1.42),
        endPoint: UnitPoint(x: 0.5, y: 1)
        )
    let chartGradientLine = LinearGradient(
        stops: [
            Gradient.Stop(color: Color(red: 1, green: 0.57, blue: 0), location: 0.00),
            Gradient.Stop(color: Color(red: 0.16, green: 0.13, blue: 0.07), location: 1.00),
        ],
        startPoint: UnitPoint(x: 1.02, y: 0.98),
        endPoint: UnitPoint(x: -0.04, y: -0.11)
        )
    var body: some View {
        ZStack {
        
            Chart {
                ForEach(animatedDataSample) { item in
                    AreaMark(
                        x: .value("", item.day),
                        y: .value("", item.wordsAdded)
                        
                    )
                    .foregroundStyle(chartGradientArea)
                    .interpolationMethod(.catmullRom)
                  
                    LineMark(
                        x: .value("", item.day),
                        y: .value("", item.wordsAdded)
                    )
                    .foregroundStyle(chartGradientLine)
                    .interpolationMethod(.catmullRom)
                    .shadow(radius: 2, x: 0, y: 2)
                    
                }
            }
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            .frame(height: 30)
            .frame(width: 100)
            .onAppear {
                prepareAnimation()
            }
          
            
        }
    }
    func prepareAnimation() {
            animatedDataSample = dataSample.map { word in
                var startWord = word
                startWord.wordsAdded = 0  // Start with 0 words added
                return startWord
            }
            // Trigger the actual animation after a brief delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                animateGraph()
            }
        }
    func animateGraph() {
            for index in animatedDataSample.indices {
                withAnimation(.easeOut(duration: 1.0)) {
                    animatedDataSample[index].wordsAdded = dataSample[index].wordsAdded
                }
            }
        }
}

struct TotalWordsChart_Preview: PreviewProvider {
  
    static var previews: some View {
        let sampleData = (1...7).map { day -> TotalWords in
            let date = Calendar.current.date(byAdding: .day, value: -day, to: Date())!
            return TotalWords(day: date, wordsAdded: Double.random(in: 100...500))
        }
        
        TotalWordsChart(dataSample: .constant(sampleData))
    }
}
