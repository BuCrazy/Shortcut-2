//
//  RounderProgressBar.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 8/20/24.
//

import SwiftUI

struct RoundedProgressBar: View {
    var progress: CGFloat
    
    //NOTE: Prevent progress from exeding 100%
    private var clampedProgress: CGFloat {
        min(max(progress, 0), 1)
    }
    var body: some View {
        VStack(alignment:.leading, spacing: 4) {
            Text("\(Int(clampedProgress * 100))%")
                .font(.system(size: 12))
                .fontWeight(.semibold)
                .foregroundStyle(Color("mainCardBG"))
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background bar
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("currentGoalProgress 1"))
                        .frame(height: 8)
                    
                    // Foreground bar (progress)
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("currentGoalProgress 2"))
                        .frame(width: clampedProgress * geometry.size.width, height: 8) // Adjust width based on progress
                }
                
            }
        }
    }
}

#Preview {
    RoundedProgressBar(progress: 0.25)
}
