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
    @State var bottomCardPadding: CGFloat = 16
    @State private var timer: Timer? // Test Jul 5
    @State var timeToBecomeWider: Bool = false
    
    let impact = UIImpactFeedbackGenerator(style: .light)
   
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
            impact.prepare()
            
            // Start a new timer
            timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
                timeToBecomeWider = true
                
                //TopCard Changes on timer
                withAnimation(.bouncy(duration: 1.3)) {
                    topCardOffsetY = 900
                    topCardScale = 0.5
                   
                }
                withAnimation(.linear(duration: 0.2)) {
                    topCardOpacity = 0.0
                }
                
                //Second Card Changes on timer
                withAnimation(.bouncy(duration: 1.3)) {
                    bottomCardOffsetY = 16
                  //  bottomCardPadding = 16
                    bottomCardScale = 1.0
                    
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 ) {
                impact.impactOccurred()
                print ("first card impact")
            }
            //Bottom Card Original Appearance
            withAnimation(.bouncy(duration: 0.8)) {
                bottomCardOpacity = 1.0
                bottomCardOffsetY = 0
                bottomCardScale = 0.9
                bottomCardOffestZ = 0
               
                
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                impact.impactOccurred()
                print ("second card impact")
            }
            //Top Card Original Appearance
            withAnimation(.bouncy(duration: 0.8).delay(0.2)) {
                topCardOffsetZ  = 0
                topCardOffsetY = 0
                topCardScale = 1.0
                let impact = UIImpactFeedbackGenerator(style: .light)
                impact.impactOccurred()
                
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
