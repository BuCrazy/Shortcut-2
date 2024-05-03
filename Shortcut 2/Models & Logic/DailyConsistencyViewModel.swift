//
//  DailyConsistencyViewModel.swift
//  Shortcut 2
//
//  Created by Pavlo Bilashchuk on 10/19/23.
//

import Foundation

class DailyConsistencyViewModel: ObservableObject {
    
    var activityLogDataLayer: ActivityCalendar
    @Published var dailyGoal: Int = 100
    
    init(activityLogDataLayer: ActivityCalendar) {
        self.activityLogDataLayer = activityLogDataLayer
    }
    
    func numberOfActions(for date: Date) -> Int {
        return activityLogDataLayer.numberOfActionsPerDay[activityLogDataLayer.dateToString(date: date)] ?? 0
    }

    func circleProgress(for date: Date) -> Double {
          let actions = numberOfActions(for: date)
          return actions == 0 ? 0 : Double(actions) / Double(dailyGoal)
      }
    
    func isCurrentDay(date: Date) -> Bool {
           return activityLogDataLayer.dateToString(date: date) == activityLogDataLayer.currentDate
       }
    
    var dailyGoalMessage: String {
        if let currentDate = activityLogDataLayer.stringToDate(dateString: activityLogDataLayer.currentDate){
            let currentActions = numberOfActions(for: currentDate)
            
            if currentActions < dailyGoal {
                return "\(dailyGoal - currentActions) words to daily goal"
            } else {
                return "You've completed your daily goal today!"
            }
        } else {
            return "Error retrieving current actions."
        }
    }
    
}
