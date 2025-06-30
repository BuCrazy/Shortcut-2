//
//  GoalToast_2.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 4/26/25.
//

import SwiftUI

enum GoalTostStates {
    case current
    case completed
}

struct GoalToast_2: View {
    //    @EnvironmentObject var storedNewWordItemsDataLayer: storedNewWordItems
    //    @ObservedObject var goalsManager: GoalsManager
    
    var state: GoalTostStates
    //    @State var progress: Double
    //    @State var trimEnd: CGFloat = 0.0
    
    
    @ViewBuilder
    var leftIcon: some View {
        switch state {
        case .current:
            Image("currentGoal")
                .resizable()
                .frame(width: 32,height: 32)
        case .completed:
            Image("goalNumberTwo")
                .resizable()
                .frame(width: 32,height: 32)
        }
    }
    
    var rightElement: some View {
        switch state {
        case .current:
            MockDonutChart(mode: .percentages)
        case .completed:
            MockDonutChart(mode: .checkMark)
        }
    }     //
        
        let goalName = "Complete a first quiz"
        let goalDescription = "Complete quiz with at least 80% score"
        
        let boarderGradient = LinearGradient(
            stops: [
                Gradient.Stop(color: .white.opacity(0.8), location: 0.00),
                Gradient.Stop(color: .black.opacity(0), location: 1.00),
            ],
            startPoint: UnitPoint(x: -0.25, y: -1.03),
            endPoint: UnitPoint(x: 0.15, y: 0.43)
        )
        let boarderGradient2 = LinearGradient(
            stops: [
                Gradient.Stop(color: .black.opacity(0), location: 1.00),
                Gradient.Stop(color: .white.opacity(0.2), location: 0.00),
            ],
            startPoint: UnitPoint(x: 2.0, y: 1.5),
            endPoint: UnitPoint(x: 0.15, y: 0.6)
        )
        let innerShodowGradient = LinearGradient(
            stops: [
                Gradient.Stop(color: .white, location: 0.00),
                Gradient.Stop(color: .black.opacity(0), location: 1.00),
            ],
            startPoint: UnitPoint(x: 2.62, y: 0.43),
            endPoint: UnitPoint(x: 0.3, y: 0.43)
        )
        var body: some View {
            
            //Note: Main Stack
            HStack(alignment: .center) {
                
                //Note: Inner Stack
                HStack(alignment: .top, spacing: 12) {
                    leftIcon
                    //                    .resizable()
                    //                    .frame(width: 32,height: 32)
                    
                    //Note: Text Stack
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(goalName)")
                            .fontWeight(.semibold)
                            .font(.system(size: 14))
                            .foregroundStyle(Color("MainFontColor"))
                        
                        Text("\(goalDescription)")
                            .fontWeight(.regular)
                            .font(.system(size: 10))
                            .foregroundStyle(Color("Text-secondary"))
                    }
                }
                
                Spacer()
                
                //Note: Donut Chart
                //            ZStack {
                //                Circle()
                //                    .stroke(Color("consistencyCircleGrey"),lineWidth: 5)
                //
                //                Circle()
                //                    .trim(from: 0, to: trimEnd)
                //                    .stroke(Color("consistencyCircleYellow"), style: StrokeStyle(lineWidth: 5, lineCap: .round))
                //                    .rotationEffect(.degrees(-90))
                //                    .onAppear{
                //                        withAnimation(.easeOut(duration: 1)) {
                //                            trimEnd = progress
                //                        }
                //                    }
                //
                //                rightElement
                //            }
                //            .frame(width: 40, height: 40)
                
                
                //DonutChartGoal_2(goalsManager: goalsManager, progress: 0.0)
                rightElement
               // MockDonutChart(mode: .percentages)
            }
            //  }
            .padding(24)
            .background(Color("Surface-component-primary"))
            .clipShape(.rect(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(boarderGradient ,lineWidth: 2)
                    .stroke(boarderGradient2 ,lineWidth: 1)
                    .shadow(color: Color(.white).opacity(0.8), radius: 5, x: 0, y: 1)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 16)
                    )
                    .shadow(color: Color.white.opacity(0.6), radius: 5, x: 0, y: 0)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 16)
                    )
                    .shadow(color: Color.white.opacity(0.6), radius: 5, x: 0, y: -1)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 16)
                    )
            )
        }
    }

#Preview {
//    let mockStoredItems = storedNewWordItems()
//    let goalsManager = GoalsManager(storedItems: mockStoredItems)
    
    GoalToast_2(/*goalsManager: goalsManager,*/ state: .completed)
}
    
