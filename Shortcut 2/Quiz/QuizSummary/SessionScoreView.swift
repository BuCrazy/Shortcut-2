//
//  SessionScoreView.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 4/29/24.
//

import SwiftUI

struct SessionScoreView: View {
    @Binding var correctAnswerNumber: Int
    @Binding var incorrectAnswerNumber: Int
    var sessionScore: Double
    @State var animatedNumber: Double = 0.0
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Score")
                    .font(.system(size: 13))
                    .fontWeight(.semibold)
                    .foregroundColor(Color.blue)
                    .padding(.bottom, 4)
                
                HStack(spacing: 4) {
                    Text(String(format: "%.1f%%", animatedNumber))
                        .font(.system(size: 24))
                        .bold()
                        .foregroundColor(Color.white)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                incrementScoreNumber()
                            }
                        }
                }
            }
        }
    }
    func incrementScoreNumber() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.04) {
            if animatedNumber < sessionScore {
                withAnimation(.linear(duration: 0.01)) {
                    animatedNumber += 1
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                }
                incrementScoreNumber()
            }
        }
    }
}

struct SessionScoreView_Previews: PreviewProvider {
    @State static var correctAnswerNumber: Int = 3
    @State static var incorrectAnswerNumber: Int = 7
    
    static var previews: some View {
        SessionScoreView(correctAnswerNumber: $correctAnswerNumber, incorrectAnswerNumber: $incorrectAnswerNumber, sessionScore: 42.1)
    }
}
