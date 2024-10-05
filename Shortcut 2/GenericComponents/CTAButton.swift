//
//  CTAButton.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 2/28/24.
//

import SwiftUI
import Shiny

struct CTAButton: View {
    var buttonText: String
    let ctaGradient = LinearGradient(
        stops: [
        Gradient.Stop(color: Color(red: 0.01, green: 0.01, blue: 0.01), location: 0.00),
        Gradient.Stop(color: Color(red: 0.11, green: 0.11, blue: 0.11), location: 1.00),
        ],
        startPoint: UnitPoint(x: 0.5, y: 2.6),
        endPoint: UnitPoint(x: 0.5, y: 0)
        )
    let borderGradient = LinearGradient(
           stops: [
               Gradient.Stop(color: Color(red: 0.07, green: 0.07, blue: 0.07), location: 0.54),
               Gradient.Stop(color: .white, location: 1.00),
           ],
           startPoint: UnitPoint(x: 0, y: 0.5),
           endPoint: UnitPoint(x: 1, y: 0.5)
       )
    
    var body: some View {
       // ZStack {
            HStack {
                Text(buttonText)
                    .foregroundColor(.white)
                    .font(.system(size: 16))
                    .fontWeight(.medium)
                    .padding(.vertical, 16)
                   
            }
            .frame(maxWidth: .infinity)
            .background(ctaGradient)

            .cornerRadius(48)
            .shadow(color: Color(red: 0.5, green: 0.5, blue: 0.5).opacity(0.1), radius: 3, x: 0, y: 0)
            
            .overlay(
                RoundedRectangle(cornerRadius: 26
                                )
               // .inset(by: 1.25)
                .stroke(/*Color(red: 0.07, green: 0.07, blue: 0.07),*/ lineWidth: 0.5)
             //   .blur(radius: 4)
             //   .shiny((.glossy(UIColor(white: 1.0, alpha: 0.3), intensity: 0.5)))
                    .shiny(Gradient(colors: [Color(red: 0.18, green: 0.18, blue: 0.18), Color(red: 0.07, green: 0.07, blue: 0.07)]))
            
            )
//            .overlay(
//            Image("bluredAccentLine")
//                .resizable()
//                .frame(width: 250, height: 5)
//                .offset(x: 30, y: 24)
//            )
        }
        
  //  }
}

#Preview {
    CTAButton(buttonText: "Button Name")
}
