//
//  Indicator.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 2/23/24.
//

import SwiftUI

enum AnswerStatus {
    case neutral, correct, incorrect
}

struct Indicator: View {
    var status: AnswerStatus
    private var fillColor: Color {
        switch status {
        case .neutral:
            return Color("neutral")
        case .correct:
            return Color("correct")
        case .incorrect:
            return Color("incorrect")
        }
    }
    var body: some View {
        ZStack {
            VStack {
                Spacer().frame(height: 0.2)
                HStack(alignment: .center) {
                    Spacer().frame(width: 0.1)
                    Rectangle()
                        .fill(.black)
                        .frame(width: 9, height: 9)
                        .cornerRadius(2.5)
                }
            }
            
            HStack(alignment: .center) {
                Rectangle()
                    .fill(fillColor)
                    .frame(width: 8, height: 8)
                    .cornerRadius(2)
                    .shadow(color: status == .neutral ? .clear : fillColor.opacity(0.5), radius: status == .neutral ? 0 : 2, x: 0, y: 1.5)
                   
            }
        }

    }
}

#Preview {
    Indicator(status: .correct)
}
