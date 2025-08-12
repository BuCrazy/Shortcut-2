//
//  CircularGoalProgress.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 7/17/25.
//

import SwiftUI

struct CircularGoalProgress: View {
   // @EnvironmentObject var goalsManager: GoalsManager
    let progress: CGFloat
    let status: GoalStatus
    @State private var displayProgress: CGFloat = 0


//    private var progress: CGFloat {
//         let currentProgress = CGFloat(goalsManager.currentGoal.progress)
//         print("🎨 Progress bar calculating value: \(currentProgress)")
//         print("Current goal status: \(goalsManager.currentGoal.status)")
//         
//         return min(max(currentProgress, 0), 1)
//     }
    let componentSize: CGFloat = 40
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
                  ZStack {

                      // Background circle
                      Circle()
                          .stroke(Color("Surfacehigh-contrast"), lineWidth: 4)
                          .frame(width: componentSize, height: componentSize)
                      
                      // Progress circle
                      Circle()
                          .trim(from: 0, to: displayProgress)
                          .stroke(
                              Color("currentGoalProgress 2"),
                              style: StrokeStyle(lineWidth: 4, lineCap: .round)
                          )
                          .frame(width: componentSize, height: componentSize)
                          .rotationEffect(.degrees(-90)) // Start from top
                      
                    //TEST Jul 27 (Uncommit if to get back)
//                      if goalsManager.currentGoal.status == .inProgress {
//                          // Percentage text in center
//                          Text("\(Int(displayProgress * 100))%")
//                              .font(.system(size: 10))
//                              .fontWeight(.semibold)
//                              .foregroundStyle(Color("currentGoalProgress 2"))
//                      } else if goalsManager.currentGoal.status == .completed {
//                          Image("CheckMark")
//                              .resizable()
//                              .frame(width: 24, height: 24)
//                      }
                      
                      //TEST Jul 27 (Delete if to get back)
                      if status == .completed {
                            Image("CheckMark")
                                .resizable()
                                .frame(width: 24, height: 24)
                     } else {
                    // Show percentage for all other statuses
                        Text("\(Int(progress * 100))%")
                            .font(.system(size: 10))
                            .fontWeight(.semibold)
                            .foregroundStyle( status == .notStarted ? Color("Surfacehigh-contrast") : Color("currentGoalProgress 2"))
                    }
                  }
                  .padding(2)
             //     .background(Color(.red))
               
              }
       // .animation(.easeIn(duration: 0.3), value: displayProgress)


              .onAppear {
                  displayProgress = progress
 
                  print("RoundedProgressBar appeared, progress: \(progress)")
              }
              .onChange(of: /* goalsManager.currentGoal.progress */ progress) { newValue in
                  print("📈 Progress bar detected change: \(newValue)")
                  displayProgress = newValue
              }

    }
}

#Preview {
    CircularGoalProgress(
        progress: 0.0,
        status: .notStarted
    )
}
//#Preview {
//    let mockStoredItems = storedNewWordItems()
//    let goalsManager = GoalsManager(storedItems: mockStoredItems)
//        
//    goalsManager.currentGoal.progress = 0.5
//        goalsManager.currentGoal.status = .inProgress
//        
//        return CircularGoalProgress()
//            .environmentObject(goalsManager)
////    CircularGoalProgress()
////    .environmentObject(goalsManager)
////    .onAppear {
////        goalsManager.currentGoal.progress = 1.0
////        goalsManager.currentGoal.status = .completed
//
// //       }
//
//
//}
