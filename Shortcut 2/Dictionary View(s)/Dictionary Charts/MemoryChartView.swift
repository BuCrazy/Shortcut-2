//
//  MemoryChartView.swift
//  Shortcut 2
//
//  Created by Pavlo Bilashchuk on 11/27/23.
//

import SwiftUI

struct MemoryChartView: View {
    @Binding var progress: Double
    @Binding var consecutiveCorrectRecalls: Int
    @State var trimEnd: CGFloat = 0.0
    var targetNumberOfRecalls: Int = 10
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color("consistencyCircleGrey"), lineWidth: 4)
            
            Circle()
                .trim(from: 0, to: trimEnd)
                .stroke(Color("consistencyCircleYellow"), style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .onAppear {
                    withAnimation(.easeInOut(duration: 1)) {
                        trimEnd = progress
                    }
                }
                .onChange(of: progress) { /*_ in */
                    trimEnd = progress
                }
            
            Text("\(consecutiveCorrectRecalls)/\(targetNumberOfRecalls)")
                .fontWeight(.bold)
                .font(.system(size: 12))
                .foregroundStyle(.white)
        }
        .frame(width: 44, height: 44)
    }
}

#Preview {
    MemoryChartView(progress: .constant(0.5), consecutiveCorrectRecalls: .constant(5))
}
