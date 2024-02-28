//
//  BottomPart.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 2/28/24.
//

import SwiftUI

struct BottomPart: View {
    @Binding var correctAnswerNumber: Int
    @Binding var incorrectAnswerNumber: Int
    
    var body: some View {
        ZStack {
            Color("mainCardBG").ignoresSafeArea()
            VStack {
                HStack{
                    CorrectAnswersNumber(correctAnswerNumber: $correctAnswerNumber)
                    Spacer()
                    IncorrectAnswersNumber(incorrectAnswerNumber: $incorrectAnswerNumber)
                }
                .padding(.horizontal, 20)
                .padding(.top, 32)
                
                Spacer()
                TestBarChart()
            }
            
        }
        .frame(height: 342)
    }
}

struct BottomPart_Previews: PreviewProvider {
    @State static var correctAnswerNumber: Int = 3
    @State static var incorrectAnswerNumber: Int = 7
    static var previews: some View {
        BottomPart(correctAnswerNumber: $correctAnswerNumber, incorrectAnswerNumber: $incorrectAnswerNumber)
    }
}
