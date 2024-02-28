//
//  IndicatorBar.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 2/28/24.
//

import SwiftUI

struct IndicatorBar: View {
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 15.3) {
                Indicator(status: .correct)
                Indicator(status: .incorrect)
                Indicator(status: .correct)
                Indicator(status: .correct)
                Indicator(status: .incorrect)
                Indicator(status: .incorrect)
                Indicator(status: .correct)
                Indicator(status: .incorrect)
                Indicator(status: .neutral)
                Indicator(status: .neutral)
                Indicator(status: .neutral)
                Indicator(status: .neutral)
                Indicator(status: .neutral)
                Indicator(status: .neutral)
                Indicator(status: .neutral)
                
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            
            HStack(spacing: 15.3) {
                Indicator(status: .neutral)
                Indicator(status: .neutral)
                Indicator(status: .neutral)
                Indicator(status: .neutral)
                Indicator(status: .neutral)
                Indicator(status: .neutral)
                Indicator(status: .neutral)
                Indicator(status: .neutral)
                Indicator(status: .neutral)
                Indicator(status: .neutral)
                Indicator(status: .neutral)
                Indicator(status: .neutral)
                Indicator(status: .neutral)
                Indicator(status: .neutral)
                Indicator(status: .neutral)
            }
        }
    }
}

#Preview {
    IndicatorBar()
}
