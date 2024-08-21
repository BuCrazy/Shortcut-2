//
//  RounderProgressBar.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 8/20/24.
//

import SwiftUI

struct RoundedProgressBar: View {
    var progress: CGFloat
    
    var body: some View {
        VStack(alignment:.leading, spacing: 4) {
            Text("\(Int(progress * 100))%")
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
                        .frame(width: progress * geometry.size.width * 0.8, height: 8) // Adjust width based on progress
                }
                
            }
        }
    }
}

#Preview {
    RoundedProgressBar(progress: 0.25)
}
