//
//  CorrectAnswersNumber.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 2/23/24.
//

import SwiftUI

struct CorrectAnswersNumber: View {
    @Binding var correctAnswerNumber: Int
    @State var animatedNumber: Int = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("CORRECT ANSWERS")
                .font(.system(size: 12))
                .foregroundColor(Color("weakSecondaryDark"))
                .padding(.bottom, 4)
            
            Text("\(animatedNumber)")
                .font(.system(size: 24))
                .bold()
                .foregroundColor(Color.green)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        incrementCorrectNumber()
                    }
                }
        }
    }
    
    func incrementCorrectNumber() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
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
