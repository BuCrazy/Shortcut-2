//
//  Goal 2 Animation.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 4/14/25.
//

import SwiftUI

struct Goal_2_Animation: View {
    @Binding  var feedbackColor: Color
    @State  var timer: Timer? = nil
    var body: some View {
        P171_CircleAnimation(feedbackColor: feedbackColor)
            .blendMode(.screen)
            .blur(radius: 16)
            .transition(.opacity)
            .frame(width: 202, height: 125)
            .onAppear {
                timer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { _ in
                    withAnimation {
                        feedbackColor = feedbackColor == .green ? .red : .green
                    }
                }
                
            }
            .onDisappear {
                timer?.invalidate()
                timer = nil
            }
    }
}

#Preview {
    Goal_2_Animation(feedbackColor: .constant(.green))
}
