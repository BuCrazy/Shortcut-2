//
//  LexCard.swift
//  Shortcut 2
//
//  Created by Pavlo Bilashchuk on 11/27/23.
//

import SwiftUI

struct LexCardView: View {
    @Binding var consecutiveCorrectRecalls: Int
    @Binding var progress: Double

    var word: String
    var transcription: String
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Rectangle()
                    .fill(Color("dictionaryBGColor"))
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(word)
                            .fontWeight(.bold)
                            .font(.system(size: 20))
                            .foregroundStyle(.white)
                        
                        Text("[\(transcription)]")
                            .fontWeight(.regular)
                            .font(.system(size: 14))
                            .foregroundStyle(Color("secondaryFontColor"))
                    }
                    Spacer()
                   MemoryChartView(progress: $progress, consecutiveCorrectRecalls: $consecutiveCorrectRecalls)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 84)
            
            GeometryReader { geometry in
                HStack {
                    Spacer()
                    Rectangle()
                        .fill(Color("mainCardBG"))
                        .frame(width: geometry.size.width * 0.96, height: 1)
                }
                .frame(height: 1)
            }
        }
    }
}

#Preview {
    LexCardView(consecutiveCorrectRecalls: .constant(5), progress: .constant(0.5), word: "Dexterous", transcription: "'dekst(ə)rəs")
}
