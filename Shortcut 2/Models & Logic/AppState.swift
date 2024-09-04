//
//  AppState.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 9/2/24.
//

import SwiftUI
import Firebase 

class AppState: ObservableObject {
    @Published var dataLoaded = false
    @Published var loadTime: TimeInterval = 0
    let storedNewWordItems: storedNewWordItems
    let activityLog: ActivityCalendar
    lazy var db: Firestore = {
            return Firestore.firestore()
        }()
    
    init(storedNewWordItems: storedNewWordItems, activityLog: ActivityCalendar) {
        self.storedNewWordItems = storedNewWordItems
        self.activityLog = activityLog
    }

    func loadInitialData() {
        let startTime = Date()
        storedNewWordItems.initialWordDataLoader()
        try? activityLog.loadDataFromJSON()
        let endTime = Date()
        loadTime = endTime.timeIntervalSince(startTime)
        print("Data loading time: \(loadTime) seconds")
        dataLoaded = true
    }
}
