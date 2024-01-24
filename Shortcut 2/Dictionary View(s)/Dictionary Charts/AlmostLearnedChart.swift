//
//  AlmostLearnedChart.swift
//  Shortcut 2
//
//  Created by Pavlo Bilashchuk on 12/5/23.
//

import SwiftUI
import Foundation
import Charts

struct WordsAlmostLearned: Identifiable {
    var id = UUID().uuidString
    var hour: Date
    var almostLearnedWords: Double
    var animate: Bool = false
}

extension Date {
    // MARK to update  date for particular hour
    func updateHour(value: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(bySettingHour: value, minute: 0, second: 0, of: self) ?? .now
    }
}

var sample_Data: [WordsAlmostLearned] = [
    WordsAlmostLearned(hour: Date().updateHour(value: 1), almostLearnedWords: 4),
    WordsAlmostLearned(hour: Date().updateHour(value: 5), almostLearnedWords: 5),
    WordsAlmostLearned(hour: Date().updateHour(value: 7), almostLearnedWords: 2),
    WordsAlmostLearned(hour: Date().updateHour(value: 8), almostLearnedWords: 2),
    WordsAlmostLearned(hour: Date().updateHour(value: 10), almostLearnedWords: 1),
    WordsAlmostLearned(hour: Date().updateHour(value: 13), almostLearnedWords: 5)
]

struct AlmostLearnedChart: View {
    @State var sampleData: [WordsAlmostLearned] = sample_Data
    @Binding var resetAnimationTrigger: Bool 
    let chartGradientArea = LinearGradient(
        stops: [
        Gradient.Stop(color: Color(red: 0.39, green: 0.87, blue: 0.09), location: 0.00),
        Gradient.Stop(color: Color(red: 0.39, green: 0.87, blue: 0.09).opacity(0.3), location: 0.51),
        Gradient.Stop(color: Color(red: 0.39, green: 0.87, blue: 0.09).opacity(0), location: 1.00),
        ],
        startPoint: UnitPoint(x: 0.5, y: -1.42),
        endPoint: UnitPoint(x: 0.5, y: 1)
        )
    let chartGradientLine = LinearGradient(
        stops: [
        Gradient.Stop(color: Color(red: 0.39, green: 0.87, blue: 0.09), location: 0.00),
        Gradient.Stop(color: Color(red: 0.12, green: 0.16, blue: 0.09), location: 1.00),
        ],
        startPoint: UnitPoint(x: 1.02, y: 0.98),
        endPoint: UnitPoint(x: -0.04, y: -0.11)
        )
    var body: some View {
        ZStack {
            Chart {
                ForEach(sampleData) { item in
                    AreaMark(
                        x: .value("", item.hour, unit: .hour),
                        y: .value("", item.animate ? item.almostLearnedWords : 0)
                    )
                
                    .foregroundStyle(chartGradientArea)
                    .interpolationMethod(.catmullRom)
                    
                    LineMark(
                        x: .value("", item.hour, unit: .hour),
                        y: .value("", item.animate ? item.almostLearnedWords : 0)
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
            .onChange(of: resetAnimationTrigger) {
                if resetAnimationTrigger {
                    resetAnimation()
                    resetAnimationTrigger = false // Reset the trigger
                }
            }
            .onAppear {
                animateGraph()
            }
        }
    }
    func resetAnimation() {
            // Reset animation logic
            for (index, _) in sampleData.enumerated() {
                sampleData[index].animate = false
            }
            animateGraph(fromChange: true)
        }
    
    func animateGraph(fromChange: Bool = false) {
        for (index,_) in sampleData.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * (fromChange ? 0.03 : 0.05)) {
                withAnimation(fromChange ? .easeOut(duration: 0.8) : .interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
                    sampleData[index].animate = true
                }
            }
        }
    }
}

struct AlmostLearnedChart_Preview: PreviewProvider {
    @State static var resetAnimationTrigger = false
    static var previews: some View {
        AlmostLearnedChart(resetAnimationTrigger: $resetAnimationTrigger)
    }
}
