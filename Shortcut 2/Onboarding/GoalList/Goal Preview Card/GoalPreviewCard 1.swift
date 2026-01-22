//
//  GoalPreviewCard.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 7/16/25.
//

import SwiftUI
import AVKit
import AVFoundation

struct GoalPreviewCard_1: View {
    @EnvironmentObject var goalsManager: GoalsManager
    let goalName = "Discover 30 unknown words"
    let goalDescription = "Swipe down the cards with unknown words."
    var BrG_ExpendedCard = LinearGradient(
        stops: [
        Gradient.Stop(color: .white, location: 0.00),
        Gradient.Stop(color: .black.opacity(0), location: 1.00),
        ],
        startPoint: UnitPoint(x: -0.25, y: -1.03),
        endPoint: UnitPoint(x: 0.5, y: 0.43)
        )
    var BrG_CollapsedCard = LinearGradient(
        stops: [
                Gradient.Stop(color: .white, location: 0.0),
                Gradient.Stop(color: .white.opacity(0.2), location: 0.15),
                Gradient.Stop(color: .clear, location: 0.3),
            ],
        startPoint: UnitPoint(x: 0.05, y: -0.4),
            endPoint: UnitPoint(x: 0.3, y: 0.15)
        )
    var BG_NotStartedGoal = LinearGradient(
        stops: [
        Gradient.Stop(color: Color(red: 0.09, green: 0.09, blue: 0.09).opacity(0), location: 0.00),
        Gradient.Stop(color: Color(red: 0.09, green: 0.09, blue: 0.09).opacity(0.81), location: 0.52),
        Gradient.Stop(color: Color(red: 0.09, green: 0.09, blue: 0.09).opacity(0.91), location: 0.70),
        Gradient.Stop(color: Color(red: 0.09, green: 0.09, blue: 0.09), location: 1.00),
        ],
        startPoint: UnitPoint(x: 0, y: 0.5),
        endPoint: UnitPoint(x: 1, y: 0.5)
        )
    
    
    //Goal State Conditional Block
    private var firstGoal: Goal {
        goalsManager.goals[0]
    }
    private var firstGoalInProress: Bool {
       // goalsManager.currentGoalIndex == 0 && goalsManager.currentGoal.status == .inProgress
        firstGoal.status == .inProgress
        }
    private var firstGoalNotStarted: Bool {
      //  goalsManager.currentGoalIndex == 0 && goalsManager.currentGoal.status == .notStarted
        firstGoal.status == .notStarted
        }

    private var firstGoalCompleted: Bool {
       // goalsManager.currentGoalIndex == 0 && goalsManager.currentGoal.status == .completed
        firstGoal.status == .completed
        }
    
    private var goalIconName: String {
        if firstGoalNotStarted {
            return "goalNumberOne_NS"
        } else if firstGoalInProress {
            return "currentGoal"
        } else {
            return "goalNumberOne"
        }
    }
    
    private var cardheight: CGFloat {
        return firstGoalInProress ? 320 : 80
    }
    
    private var strokeGradient: LinearGradient? {
            if firstGoalInProress {
                return BrG_ExpendedCard
            } else if firstGoalNotStarted  {
                return nil
            } else {
                return BrG_CollapsedCard
            }
        }

    private var cardBackground: some ShapeStyle {
        firstGoalNotStarted ? AnyShapeStyle(BG_NotStartedGoal) : AnyShapeStyle(Color("mainCardBG"))
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                //Header HStack
                HStack(alignment: firstGoalInProress ? .top : .center) {
                    HStack(spacing: 8) {
                        // goalNumberOne
                        Image(goalIconName)
                            .resizable()
                            .frame(width: 32, height: 32)
                        
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(goalName)
                                .font(.system(size: 14))
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                            Text(goalDescription)
                                .font(.system(size: 10))
                                .fontWeight(.regular)
                                .foregroundStyle(Color("secondaryFontColor"))
                        }
                    }
                    
                    Spacer()
                    CircularGoalProgress(
                        progress: CGFloat(/*goalsManager.currentGoal.progress*/ firstGoal.progress
),
                        status: /*goalsManager.currentGoal.status*/ firstGoal.status
                    )
                       
                    
                }
                .padding(16)
                if firstGoalInProress {
                    LocalPlayer(
                        videoName: "1st Goal Demo Double Corpped",
                        hideControls: true,
                        isLooping: true,
                        contentOffset: CGPoint(x: 0, y: 0))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .cornerRadius(8)
                    .allowsHitTesting(false)
                    .padding(.horizontal, 16)
                    .padding(.bottom,16)
                } else {}
            }
     
        }
        .frame(maxWidth: .infinity)
        .frame(height: cardheight)
        .background(cardBackground)
        .cornerRadius(24)
      
        .overlay(
            Group {
                if let strokeGradient = strokeGradient {
                    
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(strokeGradient ,lineWidth: 1)
                        .shadow(color: Color(.white).opacity(0.8), radius: 5, x: 0, y: 2)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 21)
                        )
                        .shadow(color: Color.white.opacity(0.8), radius: 5, x: 2, y: 0)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 21)
                        )
                }
            }
        )
     //   .padding(.horizontal, 16)
       
      
    }
}

#Preview {
    let mockStoredItems = storedNewWordItems()
    let goalsManager = GoalsManager(storedItems: mockStoredItems)

//    goalsManager.currentGoal.progress = 0.0
//    goalsManager.currentGoal.status = .notStarted
    goalsManager.goals[0].progress = 0.8
    goalsManager.goals[0].status = .inProgress

    
    return GoalPreviewCard_1()
        .environmentObject(goalsManager)


}
