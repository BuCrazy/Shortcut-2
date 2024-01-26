//
//  NativeLikeSymbolView.swift
//  Shortcut 2
//
//  Created by Pavlo Bilashchuk on 1/14/24.
//

import SwiftUI

struct NativeLikeSymbolView: View {
    var body: some View {
      Image("nativeLikeSymbol")
            .resizable()
            .frame(width: 50, height: 50)
            .shadow(color: Color(red: 0.58, green: 0.89, blue: 0.76).opacity(0.5), radius: 12, x: 0, y: 0)


    }
}

#Preview {
    NativeLikeSymbolView()
}
