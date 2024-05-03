//
//  DictionaryAlmostLearned.swift
//  Shortcut 2
//
//  Created by Pavlo Bilashchuk on 12/5/23.
//

import SwiftUI

struct DictionaryAlmostLearned: View {
    @State var almostLearnedWordsCount: Int = 0
    var almostlearnedUpdate: Int = 8
    @State var finalTargetValue: Int = 0    
    @State private var appeared: Bool = false
    @State private var hasAnimated: Bool =  false
    @State var resetChartAnimation: Bool //TEST
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack {
                    HStack (alignment: .bottom) {
                        Text("\(almostLearnedWordsCount)")
                            .font(.system(size: 24))
                            .bold()
                            .foregroundStyle(.white)
                            .onAppear {
                                if !hasAnimated {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        finalTargetValue = almostLearnedWordsCount + almostlearnedUpdate
                                        incrementTotalNumber()
                                    }
                                }
                            }
                    }
                    HStack(alignment: .bottom) {
                        AlmostLearnedChart(resetAnimationTrigger: $resetChartAnimation)
                    }
                }
                .padding(.bottom, 4)
                
                Text("Almost Learned")
                    .font(.system(size: 12))
                    .foregroundStyle(Color("SecondaryTextColor"))
            }
        }
    }
    
    func incrementTotalNumber() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.03) {
            
            if almostLearnedWordsCount < finalTargetValue {
                withAnimation(.linear(duration: 0.01)) {
                    almostLearnedWordsCount += 1
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                }
                incrementTotalNumber()
                hasAnimated = true
            }
        }
    }
}

struct DictionaryAlmostLearned_Preview: PreviewProvider {
    @State static var resetAnimationTrigger = false // TEST
    static var previews: some View {
        DictionaryAlmostLearned(resetChartAnimation: resetAnimationTrigger)
    }
}
