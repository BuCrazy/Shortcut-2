//
//  DictionaryHeaderView.swift
//  Shortcut 2
//
//  Created by Pavlo Bilashchuk on 12/6/23.
//

import SwiftUI

struct DictionaryHeaderView: View {
    @Binding var resetChartAnimation: Bool
    @Binding var animatedNumber: Int
    @Binding var chartData: [TotalWords]

    var body: some View {
        ZStack {
            HStack {
                DictionaryTotalWords(chartData: $chartData, animatedNumber: $animatedNumber, resetChartAnimation: resetChartAnimation)
                Spacer()
                DictionaryAlmostLearned(resetChartAnimation: resetChartAnimation)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .padding(.horizontal, 16)
        }
        .background(Color("mainCardBG"))
    }
}

struct DictionaryHeaderView_Preview: PreviewProvider {
    static let sampleChartData = [
            TotalWords(day: Date(), wordsAdded: 5.0),
            TotalWords(day: Date().addingTimeInterval(-86400), wordsAdded: 3.0)
        ]
    @State static var resetAnimationTrigger = false // TEST
    @State static var animatedNumber = 10
    static var previews: some View {
        DictionaryHeaderView(resetChartAnimation: $resetAnimationTrigger, animatedNumber: $animatedNumber, chartData: .constant(sampleChartData))
    }
}
