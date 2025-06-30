//
//  DonutChartGoal_1.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 4/26/25.
//

import SwiftUI

struct DonutChartGoal_1: View {
    var progress = 1.0
    @State var trimEnd: CGFloat = 0.0
    
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
            
            CheckMarkAnimated()
        }
        .frame(width: 48, height: 48)
    }
}

#Preview {
    DonutChartGoal_1()
}

