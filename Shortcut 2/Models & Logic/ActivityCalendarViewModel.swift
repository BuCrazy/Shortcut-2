//
//  ActivityCalendarViewModel.swift
//  Shortcut 2
//
//  Created by Pavlo Bilashchuk on 10/26/23.
//

import Foundation
import SwiftUI

class ActivityCalendarViewModel: ObservableObject {
    var activityLogDataLayer: ActivityCalendar
    @Published var cells: [ActivityCell] = []
    
    init(activityLogDataLayer: ActivityCalendar) {
        self.activityLogDataLayer = activityLogDataLayer
    }
    

    // Indentifiyng a Full Date of the Cell
    func getDateOfTheCell(for index: Int, currentDate: String) -> String {
        if index == 0 {
            return currentDate
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            if let date = dateFormatter.date(from: currentDate) {
             return  calculateOneDayBack(from: date, by: index)
            } else {
                return currentDate
            }
        }
    }
    
    func calculateOneDayBack(from date: Date, by days: Int) -> String {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let newDate = calendar.date(byAdding: .day, value: days, to: date) {
                return dateFormatter.string(from: newDate)
            } else {
                return dateFormatter.string(from: date)
        }
    }
    
    func getDay(from date: String) -> Int {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyyy-MM-dd"
          let date = dateFormatter.date(from: date) ?? Date()
          return Calendar.current.component(.day, from: date)
      }
    
    func getMonth(from date: String) -> Int {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy-MM-dd"
           let date = dateFormatter.date(from: date) ?? Date()
           return Calendar.current.component(.month, from: date)
       }
    
    // LEARN
    func getMonthName(monthsBack: Int) -> String {
        let calendar = Calendar.current
        let dateComponents = DateComponents(month: -monthsBack)
        if let newDate = calendar.date(byAdding: dateComponents, to: Date()) {
                let month = calendar.component(.month, from: newDate)
                let monthName = DateFormatter().monthSymbols[month - 1]
            return String(monthName.prefix(3))
            }
            return "Unknown"
    } 
    
}
    
    


struct ActivityCell {
    var date: String
    var dayAndMonth: String
    var dayOfTheMonth: String
    var currentMonth: String
    var numberOfActions: Int
    var percentageOfTheHighestNumberOfActions: Double
    var cellColor: Color
    var monthAsItSounds: String
    var startingMonthName: String
}
