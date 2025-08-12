//
//  CardContainer.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 7/20/25.
//

import SwiftUI

struct CardContainer: View {
    var body: some View {
        ZStack {
            Color(.gray)
            VStack(alignment: .leading, spacing: 0) {
                //Header
                HStack(alignment: .top, spacing: 12) {
                    Image("analytics")
                        .resizable()
                        .frame(width: 20, height: 20)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Detailed personal progress analytics ")
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                        Text("Progress stats, consistency charts and level analytics")
                            .font(.system(size: 10))
                            .fontWeight(.regular)
                            .foregroundStyle(Color("secondaryText2"))
                    }
                }
                .padding(16)
                
                LocalPlayer(
                    videoName: "1st Goal Demo Double Corpped",
                    hideControls: true,
                    isLooping: true,
                   // videoGravity: .resizeAspect,
                    contentOffset: CGPoint(x: 0, y: 0))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .cornerRadius(8)
                .allowsHitTesting(false)
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
            
        }
        .frame(maxWidth: .infinity)
        .frame(height: 320)
        .cornerRadius(24)
        .padding(.horizontal, 16)
    }
}

#Preview {
    CardContainer()
}
