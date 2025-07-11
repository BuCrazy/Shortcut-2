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
    @State var bottomCardPadding: CGFloat = 32
    @State private var timer: Timer? // Test Jul 5
    @State var timeToBecomeWider: Bool = false
    
    
   
    var body: some View {
        ZStack {
            GoalToast_2(state: .current)
                .padding(.horizontal,bottomCardPadding)
                .offset(x: 0, y: -16 + bottomCardOffsetY)
                .opacity(bottomCardOpacity)
                .scaleEffect(bottomCardScale)
            
            GoalToast_1()
                .padding(.horizontal, 16)
                .offset(y: topCardOffsetY)
                .opacity(topCardOpacity)
                .scaleEffect(topCardScale)
              //  .offset(y: timeToGo ? 600 : topCardOffsetY )
        }
        .onAppear {
            // Cancel any existing timer
                timer?.invalidate()
            
            
            // Start a new timer
            timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
                timeToBecomeWider = true
                //TopCard Changes on timer
                withAnimation(.bouncy(duration: 1.5)) {
                    topCardOffsetY = 900
                    topCardScale = 0.5
                }
                withAnimation(.linear(duration: 0.2)) {
                    topCardOpacity = 0.0
                }
                
                //Second Card Changes on timer
                withAnimation(.bouncy(duration: 1.5)) {
                    bottomCardOffsetY = 16
                    bottomCardPadding = 16
                    
                }
            }
            
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
