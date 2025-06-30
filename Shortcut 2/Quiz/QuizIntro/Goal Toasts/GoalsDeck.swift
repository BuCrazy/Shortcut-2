//
//  GoalsDeck.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 5/7/25.
//

import SwiftUI

struct GoalsDeck: View {
    @State var topCardOffsetY: CGFloat = 40
    @State var topCardOpacity: Double = 0.0
    @State var topCardScale: CGFloat = 0.5
    @State var topCardOffsetZ: CGFloat = -20
    
    @State var bottomCardOffsetY: CGFloat = 20
    @State var bottomCardOpacity: Double = 0.0
    @State var bottomCardScale: CGFloat = 0.5
    @State var bottomCardOffestZ: CGFloat = -20
    
    
    var body: some View {
        ZStack {
            GoalToast_2(state: .current)
                .padding(.horizontal, 32)
                .offset(x: 0, y: -16 + bottomCardOffsetY)
                .opacity(bottomCardOpacity)
                .scaleEffect(bottomCardScale)
            
            GoalToast_1()
                .padding(.horizontal, 16)
                .offset(y: topCardOffsetY)
                .opacity(topCardOpacity)
                .scaleEffect(topCardScale)
        }
        .onAppear {
            
            withAnimation(.bouncy(duration: 1.2)) {
                bottomCardOpacity = 1.0
                bottomCardOffsetY = 0
                bottomCardScale = 1.0
                bottomCardOffestZ = 0
            }
            
            withAnimation(.bouncy(duration: 1.2).delay(0.2)) {
                topCardOffsetZ  = 0
                topCardOffsetY = 0
                topCardScale = 1.0
            }
            
            withAnimation(.linear(duration: 0.1).delay(0.2)) {
                topCardOpacity = 1.0
            }
        }
    }
}
    #Preview {
        GoalsDeck()
    }
