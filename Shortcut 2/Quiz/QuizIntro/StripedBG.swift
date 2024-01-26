//
//  StripedBG.swift
//  Shortcut 2
//
//  Created by Pavlo Bilashchuk on 1/14/24.
//

import SwiftUI

struct StripedBG: View {
    @State private var appeared: Bool = false
    
    var body: some View {
        ZStack {
            Color("BackgroundColor").ignoresSafeArea()
            Image("stripedBG")
                .resizable()
                .scaledToFill()
        }
    }
}

#Preview {
    StripedBG()
}
