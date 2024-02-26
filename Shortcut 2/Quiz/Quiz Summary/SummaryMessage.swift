//
//  SummaryMessage.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 2/23/24.
//

import SwiftUI

struct SummaryMessage: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Well Done!")
                .font(.system(size: 24))
                .foregroundColor(.white)
                .fontWeight(.medium)
                .padding(.bottom, 8)
            
            Text("You’ve completed overview of unknown words. You can find your results below. Once you’re ready we’ll continue to mine new words.")
                .font(.system(size: 14))
                .foregroundColor(Color("SecondaryTextColor"))
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    SummaryMessage()
}
