//
//  ChartSampleData.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 2/28/24.
//

import Foundation

struct ChartSampleData: Identifiable {
        var id = UUID().uuidString
        var hour: Date
        var wordsAdded: Double
        var animate: Bool = false
}

extension Date {
    // MARK to update  date for particular hour
    func updateHours(value: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(bySettingHour: value, minute: 0, second: 0, of: self) ?? .now
    }
}

var sample_Aalytics: [ChartSampleData] = [
    ChartSampleData(hour: Date().updateHours(value: 8), wordsAdded: 2000, animate: false),
    ChartSampleData(hour: Date().updateHours(value: 9), wordsAdded: 4000, animate: false),
    ChartSampleData(hour: Date().updateHours(value: 10), wordsAdded: 5000, animate: false),
    ChartSampleData(hour: Date().updateHours(value: 11), wordsAdded: 7000, animate: false),
    ChartSampleData(hour: Date().updateHours(value: 12), wordsAdded: 8000, animate: false),
    ChartSampleData(hour: Date().updateHours(value: 13), wordsAdded: 10000, animate: false),
    ChartSampleData(hour: Date().updateHours(value: 14), wordsAdded: 14000, animate: false),
    ChartSampleData(hour: Date().updateHours(value: 15), wordsAdded: 16000, animate: false),
    ChartSampleData(hour: Date().updateHours(value: 16), wordsAdded: 20000, animate: false),
    ChartSampleData(hour: Date().updateHours(value: 17), wordsAdded: 24000, animate: false),
    ChartSampleData(hour: Date().updateHours(value: 18), wordsAdded: 16000, animate: false),
    ChartSampleData(hour: Date().updateHours(value: 19), wordsAdded: 8000, animate: false)
]
