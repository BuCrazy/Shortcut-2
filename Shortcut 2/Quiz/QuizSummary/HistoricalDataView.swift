//
//  HistoricalDataView.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 4/29/24.
//

import SwiftUI

struct HistoricalDataView: View {
    var quizHistory: QuizHistory
    
    var body: some View {
        HStack {
            VStack (alignment: .leading, spacing: 16) {
                Text("Historical Data")
                    .font(.system(size: 15))
                    .bold()
                    .padding(.top, 16)
                    .padding(.leading, 16)
                
                
                QuizChartResultsView(quizHistory: quizHistory)
                    .padding(.horizontal, 16)
                QuizScoreChart(quizHistory: quizHistory)
                    .frame(height: 216)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
   
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color("mainCardBG"))
        .cornerRadius(10)
    }
}

struct HistoricalDataView_Previews: PreviewProvider {
    static var quizHistory = QuizHistory()
    static var previews: some View {
        HistoricalDataView(quizHistory: quizHistory)
    }
}
