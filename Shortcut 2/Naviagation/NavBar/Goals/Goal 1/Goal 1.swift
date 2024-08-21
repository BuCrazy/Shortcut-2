//
//  Goal 1.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 8/20/24.
//

import SwiftUI

struct Goal_1: View {
    @EnvironmentObject var storedNewWordItemsDataLayer: storedNewWordItems
    @AppStorage("currentLevelSelected_key") var currentLevelSelected: String = "elementary"
    @AppStorage("wordsPerQuiz_key") var wordsPerQuiz: Int = 30
    @AppStorage("wordsPerDiscovery_key") var wordsPerDiscovery: Int = 100
    
    @State private var wordsPerFirstGoal: Int = 30
    @State var firstGoalIsCompleted = false
    var firstGoalProgress: Double {
        if firstGoalIsCompleted != true {
            switch currentLevelSelected {
            case "elementary":
                return Double(storedNewWordItemsDataLayer.elementaryBeingLearned.count) / Double(wordsPerFirstGoal)
            case "beginner":
                return Double(storedNewWordItemsDataLayer.beginnerBeingLearned.count) / Double(wordsPerFirstGoal)
            case "intermediate":
                return Double(storedNewWordItemsDataLayer.intermediateBeingLearned.count) / Double(wordsPerFirstGoal)
            default:
                return 0
            }
        } else {
            return 1
        }
    }
    
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
                    
                RoundedProgressBar(progress: firstGoalProgress)
                
            }
            
        }
    }
}

#Preview {
    Goal_1()
        .environmentObject(storedNewWordItems())
}
