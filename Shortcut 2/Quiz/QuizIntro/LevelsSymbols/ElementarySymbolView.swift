//
//  ElementarySymbolView.swift
//  Shortcut 2
//
//  Created by Pavlo Bilashchuk on 1/14/24.
//

import SwiftUI

struct ElementarySymbolView: View {
    var body: some View {
        ZStack {
            Image("elementarySymbol")
                .resizable()
                .frame(width: 50, height: 50)
        }
    }
}

#Preview {
    ElementarySymbolView()
}
