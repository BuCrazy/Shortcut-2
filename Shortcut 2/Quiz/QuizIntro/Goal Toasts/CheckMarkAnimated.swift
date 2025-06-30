//
//  CheckMarkAnimated.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 4/24/25.
//

import SwiftUI

struct CheckMarkAnimated: View {
    @State private var isAnimating = false
    
    var body: some View {
        if #available(iOS 17.0, *) {
            ZStack {
      
                ZStack {
                    // Background shape with shadow
                    CheckSVG()
                      .stroke(style: StrokeStyle(lineWidth: 8.0, lineCap: .round, lineJoin: .round))
                      .foregroundColor(Color(red: 0.11, green: 0.95, blue: 0.4).opacity(0.01)) // Nearly transparent
                      .shadow(color: Color(red: 0.07, green: 0.79, blue: 0.32).opacity(0.5), radius: 7, x: 0, y: 4)
                      .scaleEffect(isAnimating ? 0.3 : 0.1)
                    // Animated stroke
                    
                    CheckSVG()
                        .trim(from: 0, to: isAnimating ? 1 : 0)
                        .stroke(style: StrokeStyle(lineWidth: 8.0, lineCap: .round, lineJoin: .round))
                        .foregroundColor(Color(red: 0.11, green: 0.95, blue: 0.4))
                        .scaleEffect(isAnimating ? 0.3 : 0.1)
                }
                .frame(width: 50, height: 50)
            }
            
            .onAppear {
                withAnimation(.smooth(duration: 1)) {
                    isAnimating = true
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
}

#Preview {
    CheckMarkAnimated()
}
