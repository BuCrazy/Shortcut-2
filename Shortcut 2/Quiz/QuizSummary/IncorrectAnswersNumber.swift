//
//  IncorrectAnswersNumber.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 2/28/24.
//

import SwiftUI

struct IncorrectAnswersNumber: View {
    @Binding var incorrectAnswerNumber: Int
    @State var animatedNumber: Int = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("INCORRECT ANSWERS")
                .font(.system(size: 12))
                .foregroundColor(Color("weakSecondaryDark"))
                .padding(.bottom, 4)
            
            Text("\(animatedNumber)")
                .font(.system(size: 24))
                .bold()
                .foregroundColor(Color.red)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        incremeantIncorrentNumber()
                    }
                }
        }
    }
    
    func incremeantIncorrentNumber() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            
            if animatedNumber < incorrectAnswerNumber {
                withAnimation(.linear(duration: 0.01)) {
                    animatedNumber += 1
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                }
                incremeantIncorrentNumber()
            }
            
        }
    }
}

struct IncorrectAnswer_Previews: PreviewProvider {
    @State static var incorrectAnswerNumber: Int = 7
    
    static var previews: some View {
        IncorrectAnswersNumber(incorrectAnswerNumber: $incorrectAnswerNumber)
    }
}
