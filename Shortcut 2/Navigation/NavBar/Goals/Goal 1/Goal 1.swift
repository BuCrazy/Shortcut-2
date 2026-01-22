//
//  Goal 1.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 8/20/24.
//

import SwiftUI

struct Goal_1: View {
    @EnvironmentObject var storedNewWordItemsDataLayer: storedNewWordItems
    @ObservedObject var goalsManager: GoalsManager
    
    @AppStorage("currentLevelSelected_key") var currentLevelSelected: String = "elementary"
    @AppStorage("wordsPerQuiz_key") var wordsPerQuiz: Int = 30
    @AppStorage("wordsPerDiscovery_key") var wordsPerDiscovery: Int = 100
    
    @State private var wordsPerFirstGoal: Int = 30
    @Binding var firstGoalIsCompleted: Bool
 
    init(firstGoalIsCompleted: Binding<Bool>, goalsManager: GoalsManager) { // Test Jan 2 (remove goalsManager line to get back)
        _firstGoalIsCompleted = firstGoalIsCompleted
        self.goalsManager = goalsManager // Test Jan 2 (remove this line to get back)
    }
    
//    var firstGoalProgress: Double {
//        if firstGoalIsCompleted != true {
//            switch currentLevelSelected {
//            case "elementary":
//                return Double(storedNewWordItemsDataLayer.elementaryBeingLearned.count) / Double(wordsPerFirstGoal)
//            case "beginner":
//                return Double(storedNewWordItemsDataLayer.beginnerBeingLearned.count) / Double(wordsPerFirstGoal)
//            case "intermediate":
//                return Double(storedNewWordItemsDataLayer.intermediateBeingLearned.count) / Double(wordsPerFirstGoal)
//            default:
//                return 0
//            }
//        } else {
//            return 1
//        }
//    }
    
    var goalDescription = "Swipe down 30 unknown words into “Don’t Know” category."
    
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
                    .foregroundStyle(Color("mainCardBG"))
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("\(goalDescription)")
                    .font(.system(size: 10))
                    .foregroundStyle(Color("mainCardBG")).opacity(0.8)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    
                RoundedProgressBar()
                    .environmentObject(goalsManager)
                
            }
        }
        .onAppear {
            print("🎯 Goal_1 appeared")
            print("storedItems count: \(storedNewWordItemsDataLayer.elementaryBeingLearned.count)")
        }
        .onChange(of: storedNewWordItemsDataLayer.elementaryBeingLearned.count) { _, _ in
            goalsManager.updateStoredItems(storedNewWordItemsDataLayer)
        }
        .onChange(of: storedNewWordItemsDataLayer.beginnerBeingLearned.count) { _, _ in
            goalsManager.updateStoredItems(storedNewWordItemsDataLayer)
        }
        .onChange(of: storedNewWordItemsDataLayer.intermediateBeingLearned.count) { _, _ in
            goalsManager.updateStoredItems(storedNewWordItemsDataLayer)
        }
    }
}

#Preview {
    let mockStoredItems = storedNewWordItems()
    let goalsManager = GoalsManager(storedItems: mockStoredItems)
    
    return Goal_1(
        firstGoalIsCompleted: .constant(false),
        goalsManager: goalsManager
    )
    .environmentObject(mockStoredItems)
}
