//
//  Skeo Button.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 8/9/25.
//

import SwiftUI

struct Skeo_Button: View {
    var buttonLabel: String
    var action: () -> Void
    var borderGradient1 = LinearGradient( stops: [
                            Gradient.Stop(color: Color(red: 0.08, green: 0.08, blue: 0.08), location: 0.00),
                            Gradient.Stop(color: Color(red: 0.11, green: 0.11, blue: 0.11), location: 1.00),
                           ],
                            startPoint: UnitPoint(x: 0.5, y: 1),
                            endPoint: UnitPoint(x: 0.5, y: 0)
                            )
    var labelGradient = LinearGradient( stops: [
                            Gradient.Stop(color: Color(red: 0.72, green: 0.45, blue: 0.91), location: 0.00),
                            Gradient.Stop(color: Color(red: 0.98, green: 0.78, blue: 0.64), location: 0.49),
                            Gradient.Stop(color: Color(red: 0.98, green: 0.85, blue: 0.76), location: 1.00),
                        ],
                        startPoint: UnitPoint(x: 0.38, y: 0.5),
                        endPoint: UnitPoint(x: 0.67, y: 0.5)
                        )
    
    init(buttonLabel: String, action: @escaping () -> Void) {
        self.buttonLabel = buttonLabel
        self.action = action
    }

    
    var body: some View {
        Button(action: action) {
            ZStack {
                //BG 1
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 358, height: 50)
                    .background(
                        LinearGradient(
                            stops: [
                                Gradient.Stop(color: Color(red: 0.08, green: 0.08, blue: 0.08), location: 0.00),
                                Gradient.Stop(color: Color(red: 0.11, green: 0.11, blue: 0.11), location: 1.00),
                            ],
                            startPoint: UnitPoint(x: 0.5, y: 1),
                            endPoint: UnitPoint(x: 0.5, y: 0)
                        )
                    )
                    .cornerRadius(100)
                    .shadow(color: .black.opacity(0.17), radius: 2, x: 0, y: 1)
                    .offset(y: 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 100)
                            .strokeBorder(
                                LinearGradient(
                                    stops: [
                                        Gradient.Stop(color: Color(red: 0.18, green: 0.12, blue: 0.28), location: 0.00),
                                        Gradient.Stop(color: Color(red: 0.47, green: 0.19, blue: 0.62), location: 0.19),
                                        Gradient.Stop(color: Color(red: 0.56, green: 0.17, blue: 0.22), location: 0.61),
                                        Gradient.Stop(color: Color(red: 0.38, green: 0.11, blue: 0.12), location: 1.00),
                                    ],
                                    startPoint: UnitPoint(x: 0.01, y: 0.8),
                                    endPoint: UnitPoint(x: 0.99, y: 0.78)
                                ),
                                lineWidth: 2
                            )
                            .offset(y: 2)
                    )
                
                //BG 2
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 359, height: 50)
                
                    .background(
                        LinearGradient(
                            stops: [
                                Gradient.Stop(color: Color(red: 0.08, green: 0.08, blue: 0.08), location: 0.00),
                                Gradient.Stop(color: Color(red: 0.11, green: 0.11, blue: 0.11), location: 1.00),
                            ],
                            startPoint: UnitPoint(x: 0.5, y: 1),
                            endPoint: UnitPoint(x: 0.5, y: 0)
                        )
                    )
                    .cornerRadius(100)
                    .shadow(color: .black.opacity(0.17), radius: 2, x: 0, y: 1)
                    .overlay(
                        RoundedRectangle(cornerRadius: 100)
                            .strokeBorder(
                                LinearGradient( stops: [
                                    Gradient.Stop(color: Color.white, location: 0.5),
                                    Gradient.Stop(color: Color("component-secondary").opacity(0), location: 0.9)
                                ],
                                                startPoint: UnitPoint(x: 0.0, y: -1.5),
                                                endPoint: UnitPoint(x: 0.1, y: 0.7)
                                              ),
                                lineWidth: 1
                            )
                        
                    )
                //BG 2
                
                //Elipse
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(maxWidth: .infinity)
                    .frame(/*width: 339, */height: 15)
                    .background(Color(red: 0.19, green: 0.17, blue: 0.21).opacity(0.7))
                    .cornerRadius(385)
                    .blur(radius: 12)
                    .offset(y: -17)
                
                Text("\(buttonLabel)")
                    .foregroundStyle(labelGradient)
                    .font(.system(size: 16))
                    .fontWeight(.semibold)
                //       .shimmering(animation: .timingCurve(0.2, 0, 0.8, 1, duration: 2).speed(0.5).repeatForever(autoreverses: false))
                
                
            }
            
        }//button ends
        .buttonStyle(PlainButtonStyle())

    }
}

#Preview {
    Skeo_Button(buttonLabel: "Button Lable") {
        print ("Skeo Pressed")
    }

}
