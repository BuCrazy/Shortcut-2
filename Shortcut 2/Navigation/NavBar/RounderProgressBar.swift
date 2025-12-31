//
//  RounderProgressBar.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 8/20/24.
//

import SwiftUI

struct RoundedProgressBar: View {
    @EnvironmentObject var goalsManager: GoalsManager //April 14
    @State private var displayProgress: CGFloat = 0 //April 14
    
    var progressBarLableColor: Color { //April 14
        goalsManager.currentGoalIndex == 0 ? Color("mainCardBG")  : Color.white
    }
   // var progress: CGFloat
   // April 14
    private var progress: CGFloat {
        let currentProgress = CGFloat(goalsManager.currentGoal.progress)
        print("🎨 Progress bar calculating value: \(currentProgress)")
        print("Current goal status: \(goalsManager.currentGoal.status)")
        
        return min(max(currentProgress, 0), 1)
    }
    
    //NOTE: Prevent progress from exeding 100%
//    private var clampedProgress: CGFloat {
//        min(max(progress, 0), 1)
//    } //April 14 (uncommit to get back)
    
    var body: some View {
        VStack(alignment:.leading, spacing: 4) {
            Text("\(Int(displayProgress * 100))%")
                .font(.system(size: 12))
                .fontWeight(.semibold)
                .foregroundStyle(progressBarLableColor)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background bar
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("currentGoalProgress 1"))
                        .frame(height: 8)
                    
                    // Foreground bar (progress)
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("currentGoalProgress 2"))
                        .frame(width: displayProgress * geometry.size.width, height: 8) // Adjust width based on progress
                }
                
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: displayProgress)
        .onAppear {
            displayProgress = progress
            print("RoundedProgressBar appeared, progress: \(progress)")
        }
        .onChange(of: goalsManager.currentGoal.progress) {_,  newValue in
            print("📈 Progress bar detected change: \(newValue)")
        }
    }
}

#Preview {
    let mockStoredItems = storedNewWordItems()
    let goalsManager = GoalsManager(storedItems: mockStoredItems)
    goalsManager.currentGoal.progress = 0.25
    return RoundedProgressBar(/*progress: 0.25*/)
        .environmentObject(goalsManager)
}
//(Original preview was: RoundedProgressBar(progress: 0.25))
