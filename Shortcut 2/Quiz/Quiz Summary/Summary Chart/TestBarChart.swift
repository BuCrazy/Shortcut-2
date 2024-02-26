//
//  TestBarChart.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 2/23/24.
//

import SwiftUI
import Charts

struct TestBarChart: View {
    @State var sampleAnalytics : [ChartSampleData] = sample_Aalytics
    @State var currentTab: String = "7 Days"
    @State private var animateChart = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("mainCardBG").ignoresSafeArea()
                VStack {
                    animatedChart()
                }
                .frame(maxWidth: .infinity, maxHeight: 350, alignment: .top)
                .padding()
              //  .navigationTitle("Swift Charts")
                // MARK. LEARN THIS
                .onChange(of: currentTab) { newValue in
                    sampleAnalytics = sample_Aalytics
                    if newValue != "7Days" {
                        for (index,_) in sampleAnalytics.enumerated(){
                            sampleAnalytics[index].wordsAdded = .random(in: 500...100000)
                        }
                    }
                    animateGraph(fromChange: true)
                } // END MARK
            }
        }
    }
    
    @ViewBuilder
    func animatedChart() -> some View {
        Chart {
            ForEach(sampleAnalytics) { item in
                BarMark(
                    x: .value("Hour", item.hour, unit: .hour),
                    y: .value("Words Added", item.animate ? item.wordsAdded : 0)
                )
                .interpolationMethod(.catmullRom)
                .shadow(radius: 2, x: 0, y: 3)
            }
        }
        
        .onAppear{
            animateGraph()
        }
    }
    func animateGraph(fromChange: Bool = false) {
        for (index,_) in sampleAnalytics.enumerated(){
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * (fromChange ? 0.03 : 0.05)) {
                withAnimation(fromChange ? .easeOut(duration: 0.8) : .interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
                    sampleAnalytics[index].animate = true
                }
            }
        }
    }
    
}

#Preview {
    TestBarChart()
}
