//
//  MockDonutChart.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 4/27/25.
//

import SwiftUI

enum MockDonutChartMode {
    case percentages
    case checkMark
}

struct MockDonutChart: View {

    
    @State var trimEnd: CGFloat = 0.0
    
    private var progress: Double {
        switch mode {
        case .checkMark:
            return 1.0
        case .percentages:
            return 0.0
        }
    }
    var mode: MockDonutChartMode
    
    @ViewBuilder
    var chartIndicator: some View {
       switch mode {
        case .checkMark:
           CheckMarkAnimated()
        
       case .percentages:
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
            
            chartIndicator
        }
        .frame(width: 48, height: 48)
    }
}

#Preview {

    MockDonutChart(mode: .percentages)
}
