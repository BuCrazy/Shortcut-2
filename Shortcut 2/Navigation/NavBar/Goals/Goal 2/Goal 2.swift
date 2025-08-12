//
//  Goal 2.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 4/14/25.
//

import SwiftUI

struct Goal_2: View {
    @AppStorage("currentLevelSelected_key") var currentLevelSelected: String = "elementary"
    @AppStorage("wordsPerQuiz_key") var wordsPerQuiz: Int = 30
    @AppStorage("wordsPerDiscovery_key") var wordsPerDiscovery: Int = 100
    
    @EnvironmentObject var storedNewWordItemsDataLayer: storedNewWordItems
    @ObservedObject var goalsManager: GoalsManager
    
    init(goalsManager: GoalsManager) {
            self.goalsManager = goalsManager
    }
    
    var goalDescription = "Complete your first word quiz with at least 80% score"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 16) {
                Image("currentGoal")
                    .resizable()
                    .frame(width: 32, height: 32
                    )
                Text ("Current Goal")
                    .font(.system(size: 14))
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.white)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("\(goalDescription)")
                    .font(.system(size: 10))
                    .foregroundStyle(Color.white).opacity(0.8)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                
                RoundedProgressBar()
                    .environmentObject(goalsManager)
            }
            
        }
        .onAppear {
            print("🎯 Goal_2 appeared")
            print("storedItems count: \(storedNewWordItemsDataLayer.elementaryBeingLearned.count)")
        }
    }
}

#Preview {
    let mockStoredItems = storedNewWordItems()
    let goalsManager = GoalsManager(storedItems: mockStoredItems)
  
    return Goal_2(goalsManager: goalsManager)
        .environmentObject(mockStoredItems)
}
