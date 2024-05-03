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
        HStack(spacing: 16){
            VStack(alignment: .leading, spacing: 4) {
                Text("Incorrect")
                    .font(.system(size: 13))
                    .fontWeight(.semibold)
                    .foregroundColor(Color.red)
                    .padding(.bottom, 4)
                
                HStack(spacing: 4) {
                    Text("\(animatedNumber)")
                        .font(.system(size: 24))
                        .bold()
                        .foregroundColor(Color.white)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                incremeantIncorrentNumber()
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
    func incremeantIncorrentNumber() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.04) {
            
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
