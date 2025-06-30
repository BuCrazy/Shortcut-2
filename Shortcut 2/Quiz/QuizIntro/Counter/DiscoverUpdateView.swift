//
//  DiscoverUpdateView.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 2/28/24.
//

import SwiftUI

struct DiscoverUpdateView: View {
    @State var discoverNumberUpdate: Int = 63
    
    var body: some View {
        ZStack {
            Text("+ \(discoverNumberUpdate)")
                .font(.system(size: 16))
                .fontWeight(.medium)
                .foregroundColor(.green)
                .padding(.bottom, 24)
        }
    }
}

#Preview {
    DiscoverUpdateView()
}
