//
//  AlmostLearned.swift
//  Shortcut 2
//
//  Created by Pavlo Bilashchuk on 10/16/23.
//

import SwiftUI

struct AlmostLearned: View {
    @State var almostLearned = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                HStack(alignment: .top) {
                    Text("Almost \nLearned")
                        .foregroundColor(Color("MainFontColor"))
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                    Spacer()
                    Image("ProgressIcons_AlmostRemembered")
                        .resizable()
                        .frame(width: 32, height: 32)
                }
                .padding(.top, 16)
            }
            
            Spacer()
                .frame(height: 32)
                
            VStack(alignment: .leading, spacing: 4) {
                Text("\(almostLearned)")
                    .font(.system(size: 32))
                    .foregroundColor(Color("almostLearnedOrange"))
                    .fontWeight(.semibold)
                Text("Words")
                    .font(.system(size: 12))
                    .foregroundColor(Color("MainFontColor"))
            }
            .padding(.bottom, 16)

        }
        .padding(.horizontal, 16)
        .background(Color("mainCardBG"))
        .cornerRadius(8)
    }
}

#Preview {
    AlmostLearned()
}
