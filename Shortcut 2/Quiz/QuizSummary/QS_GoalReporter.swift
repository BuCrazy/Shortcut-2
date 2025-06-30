//
//  QS_GoalReporter.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 5/10/25.
//

import SwiftUI

struct QS_GoalReporter: View {
    @EnvironmentObject var storedNewWordItemsDataLayer: storedNewWordItems
    @ObservedObject var goalsManager: GoalsManager
    
    var body: some View { //TEST June 29 (condition after && to be deleted if not working)
        if goalsManager.goals.allSatisfy({ $0.status == .completed}) && !goalsManager.hasShownCompletionToast {
            
            GoalToast_2(state: .completed)
//                .onAppear {
//                    goalsManager.hasShownCompletionToast = true
//                    goalsManager.saveState()
//                }
        } else  {
            EmptyView()
         

        }
    }
}

#Preview {
    let mockStoredItems = storedNewWordItems()
    let goalsManager = GoalsManager(storedItems: mockStoredItems)
    
    QS_GoalReporter(goalsManager: goalsManager)
}
