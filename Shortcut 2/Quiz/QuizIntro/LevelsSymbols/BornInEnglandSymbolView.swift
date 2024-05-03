//
//  BornInEnglandSymbolView.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 2/28/24.
//

import SwiftUI

struct BornInEnglandSymbolView: View {
    var body: some View {
        ZStack {
            Image("bornInEnglandSymbol")
                .resizable()
                .frame(width: 50, height: 50)
                .shadow(color: .black.opacity(0.11), radius: 21.86598, x: 9.71821, y: 9.71821)
                .shadow(color: .black.opacity(0.09), radius: 8.50344, x: 4.85911, y: 4.85911)
                .shadow(color: Color(red: 0.58, green: 0.89, blue: 0.76).opacity(0.5), radius: 11, x: 0, y: 0)
        }
    }
}

#Preview {
    BornInEnglandSymbolView()
}
