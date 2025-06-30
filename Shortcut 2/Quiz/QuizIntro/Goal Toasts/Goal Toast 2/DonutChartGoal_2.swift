//
//  DonutChart.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 4/26/25.
//

import SwiftUI

struct DonutChartGoal_2: View {
    @EnvironmentObject var storedNewWordItemsDataLayer: storedNewWordItems
    @ObservedObject var goalsManager: GoalsManager
    
    @State var progress: Double
    @State var trimEnd: CGFloat = 0.0
    
    @ViewBuilder
    var donutElement: some View {
        if goalsManager.currentGoalIndex == 1 && goalsManager.currentGoal.status == .completed {
            CheckMarkAnimated()
        } else {
            Text("0%")
                .fontWeight(.bold)
                .font(.system(size: 12))
                .foregroundStyle(Color("Surfacehigh-contrast"))
        }
    }
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color("consistencyCircleGrey"),lineWidth: 5)
            
            Circle()
                .trim(from: 0, to: trimEnd)
                .stroke(Color("consistencyCircleYellow"), style: StrokeStyle(lineWidth: 5, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .onAppear{
                    withAnimation(.easeOut(duration: 1)) {
                        trimEnd = progress
                    }
                }
            
            donutElement
        }
        .frame(width: 48, height: 48)
    }
}

#Preview {
    let mockStoredItems = storedNewWordItems()
    let goalsManager = GoalsManager(storedItems: mockStoredItems)
    
    DonutChartGoal_2(goalsManager: goalsManager, progress: 0.0)
}
