//
//  CorrectAnswersNumber.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 2/28/24.
//

import SwiftUI

struct CorrectAnswersNumber: View {
    @Binding var correctAnswerNumber: Int
    @State var animatedNumber: Int = 0
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Correct")
                    .font(.system(size: 13))
                    .fontWeight(.semibold)
                    .foregroundColor(Color.green)
                    .padding(.bottom, 4)
                
                HStack(spacing: 4) {
                    Text("\(animatedNumber)")
                        .font(.system(size: 24))
                        .bold()
                        .foregroundColor(Color.white)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                incrementCorrectNumber()
                            }
                        }
                    Text("ans")
                        .font(.system(size: 13))
                        .fontWeight(.semibold)
                        .foregroundStyle(Color("secondaryFontColor"))
                        .padding(.top, 7)
                    
                }
            }
            Rectangle()
                .frame(width: 0.5, height: 50)
                .background(Color.white).opacity(0.3)
        }
    }
    func incrementCorrectNumber() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.04) {
            if animatedNumber < correctAnswerNumber {
                withAnimation(.linear(duration: 0.01)) {
                    animatedNumber += 1
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                }
                incrementCorrectNumber()
            }
        }
    }
}

struct CorrectAnswer_Previews: PreviewProvider {
    @State static var correctAnswerNumber: Int = 3
    static var previews: some View {
        CorrectAnswersNumber(correctAnswerNumber: $correctAnswerNumber)
    }
}
