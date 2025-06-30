//
//  SummaryMessage.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 2/28/24.
//

import SwiftUI

struct SummaryMessage: View {
    @EnvironmentObject var storedNewWordItemsDataLayer: storedNewWordItems
    @ObservedObject var goalsManager: GoalsManager
    
    var successfulSummaryText = "You’ve completed a quiz of unknown words and your second goal. You can find your results below. Once you’re ready we’ll continue to the next learning mode which is practicing words from your dictionary in familiar swiper form."
        
    var failedSummaryText = "You’ve completed a quiz of unknown words. Unfortunately your score was not high enough to complete this goal. You can try again."
    
    var regularSummaryText = "You’ve completed a quiz of unknown words. You can find your results below. Once you’re ready we’ll continue to the next learning mode which is practicing words from your dictionary in familiar swiper form."
    var summaryText: String {
        if goalsManager.goals.allSatisfy({ $0.status == .completed}) && goalsManager.hasShownCompletionToast {
            regularSummaryText
        } else {
            goalsManager.currentGoal.progress >= 1.0 ? successfulSummaryText : failedSummaryText }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(summaryText)
                .font(.system(size: 14))
                .foregroundColor(Color.white).opacity(0.88)
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    let mockStoredItems = storedNewWordItems()
    let goalsManager = GoalsManager(storedItems: mockStoredItems)
    
    SummaryMessage(goalsManager: goalsManager)
}


/*  if goalsManager.goals.allSatisfy({ $0.status == .completed}) {
 EmptyView()
 } else if goalsManager.currentGoal.progress >= 1.0 {
 
 GoalToast_2
 
 } else if goalsManager.currentGoal.progress < 1.0 {
 EmptyView()
 }*/
