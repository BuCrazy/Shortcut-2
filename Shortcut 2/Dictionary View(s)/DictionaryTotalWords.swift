//
//  DictionaryTotalWords.swift
//  Shortcut 2
//
//  Created by Pavlo Bilashchuk on 12/5/23.
//
//
import SwiftUI

struct DictionaryTotalWords: View {
    @AppStorage("currentLevelSelected_key") var currentLevelSelected: String = "elementary"
    
    @State var dynamicNumber: Int = 0
    @Binding var chartData: [TotalWords]
    
    @State private var isFirstLoad = true 
    
    @Binding var animatedNumber: Int
    @State var resetChartAnimation: Bool
    var storedNewWordItemsDataLayer = storedNewWordItems()

    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack {
                    HStack(alignment: .bottom) {
                        Text("\(/*animatedNumber*/ dynamicNumber)")
                            .font(.system(size: 24))
                            .bold()
                            .foregroundStyle(.white)
                            .onAppear {
                                if isFirstLoad {
                                    dynamicNumber = 0
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        incrementTotalNumber(upTo: animatedNumber)
                                    }
                                    isFirstLoad =  false
                                } else {
                                    incrementTotalNumber(upTo: animatedNumber, startingFrom: dynamicNumber)
                                }
                            }
                            .onChange(of: currentLevelSelected) { //_ in
                                dynamicNumber = 0
                                let newCount = storedNewWordItemsDataLayer.totalWordCount(for: currentLevelSelected)
                                incrementTotalNumber(upTo: newCount)
                            }
                           
                            HStack(alignment:.bottom) {

                                TotalWordsChart(dataSample: $chartData)
                            }
                    }
                    .padding(.bottom, 4)
                }
                    Text("Total Words")
                        .font(.system(size: 12))
                        .foregroundStyle(Color("SecondaryTextColor"))
            }
        }
    }

    
    func incrementTotalNumber(upTo maxNumber: Int, startingFrom currentNumber: Int = 0) {
        if currentNumber < maxNumber {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.03) {
                withAnimation(.linear(duration: 0.01)) {
                    dynamicNumber  += 1
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                }
                incrementTotalNumber(upTo: maxNumber, startingFrom: dynamicNumber)
            }
        } else {animatedNumber = dynamicNumber}
    }
    
}
    

struct DictionaryTotalWords_Preview: PreviewProvider {
    static let sampleChartData = [
            TotalWords(day: Date(), wordsAdded: 5.0),
            TotalWords(day: Date().addingTimeInterval(-86400), wordsAdded: 3.0)
        ]
    @State static var resetAnimationTrigger = false
    static var previews: some View {
        DictionaryTotalWords(chartData: .constant(sampleChartData) ,animatedNumber: .constant(9), resetChartAnimation: resetAnimationTrigger )
    }
}
