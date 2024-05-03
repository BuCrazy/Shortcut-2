//
//  IntermediateSymbolView.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 2/28/24.
//

import SwiftUI

struct IntermediateSymbolView: View {
    var body: some View {
        ZStack {
            Image("intermediateSymbol")
                .resizable()
                .frame(width: 50, height: 50)
        }
    }
}

#Preview {
    IntermediateSymbolView()
}
