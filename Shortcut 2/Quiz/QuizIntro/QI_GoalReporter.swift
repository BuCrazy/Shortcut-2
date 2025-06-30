//
//  InformationComponenet.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 5/7/25.
//

import SwiftUI

struct QI_GoalReporter: View {
    @AppStorage("weeklySwipeCount") var weeklySwipeCount: Int = 0
    
    @EnvironmentObject var storedNewWordItemsDataLayer: storedNewWordItems
    @ObservedObject var goalsManager: GoalsManager
    
    var body: some View {
        if goalsManager.goals.allSatisfy({ $0.status == .completed}) {
            DiscoveryCounter(discoveredThisWeek: $weeklySwipeCount)
        } else {
            GoalsDeck()
        }
      
    }
}

#Preview {
    let mockStoredItems = storedNewWordItems()
    let goalsManager = GoalsManager(storedItems: mockStoredItems)
    
    QI_GoalReporter(goalsManager: goalsManager)
}
