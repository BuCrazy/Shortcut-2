//
//  EmptyStateIcon.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 7/13/25.
//

import SwiftUI

struct EmptyStateIcon: View {
    @State var feedbackColor: Color = Color.clear
    let borderGradient = LinearGradient(
        stops: [
        Gradient.Stop(color: Color(red: 0.15, green: 0.15, blue: 0.15), location: 0.00),
        Gradient.Stop(color: Color(red: 0.15, green: 0.15, blue: 0.15).opacity(0), location: 1.00),
        ],
        startPoint: UnitPoint(x: 0, y: 0.5),
        endPoint: UnitPoint(x: 1, y: 0.5)
        )
    let sizeValue: CGFloat = 80
    let cornerRadius: CGFloat = 20
    
    var body: some View {
        ZStack {
            Color("cardBG").ignoresSafeArea()
            IconBlurAnimation(feedbackColor: feedbackColor)
                .frame(width: sizeValue, height: sizeValue)
                .blendMode(.screen)
                .blur(radius: 16)
                .opacity(0.5)
            
            Image("noise")
                .resizable()
                .scaledToFit()
                .scaledToFill()
                .opacity(0.5)
                .frame(width: sizeValue, height: sizeValue)
            
            Image("noise")
                .resizable()
                .scaledToFit()
                .scaledToFill()
                .frame(width: sizeValue, height: sizeValue)
           
            HStack(alignment: .top) {
               VStack(alignment: .trailing) {
                  Image("bookmark")
                    .resizable()
                    .scaledToFit()
                    .offset(x: 20, y: -35)
                }
            
            }
        }
        .frame(width: sizeValue, height: sizeValue)
        .cornerRadius(cornerRadius)
        .overlay(
            VStack {
                LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.4), Color.clear]), startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 0.3, y: 0))
                    .frame(height: sizeValue) // Adjust height to control the spread of the inner shadow
               // Spacer()
            }
                .cornerRadius(cornerRadius)
        )
        .overlay(
            VStack {
                LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.1), Color.clear]), startPoint: UnitPoint(x: 1.4, y: 0), endPoint: UnitPoint(x: 0.5, y: 0))
                    .frame(height: sizeValue) // Adjust height to control the spread of the inner shadow
            }
            .cornerRadius(cornerRadius)
        )
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(borderGradient, lineWidth: 2)
        )
        
    }
}

#Preview {
    EmptyStateIcon()
}
