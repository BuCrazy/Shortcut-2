//
//  SummaryMessage.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 2/28/24.
//

import SwiftUI

struct SummaryMessage: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("ou’ve completed a quiz of unknown words. You can find your results below. \n \nOnce you’re ready we’ll continue to the next learning mode which is practicing words from your dictionary in familiar swiper form.")
                .font(.system(size: 14))
                .foregroundColor(Color.white).opacity(0.88)
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    SummaryMessage()
}
