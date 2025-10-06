//
//  StripedBG.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 2/28/24.
//

import SwiftUI

struct StripedBG: View {
    @State private var appeared: Bool = false
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")//.ignoresSafeArea()  //TEST
                .frame(maxWidth: .infinity) //TEST
                .frame(height: 250)
                .overlay (//TEST
            Image("stripedBG")
                .resizable()
                .scaledToFill()
                .allowsHitTesting(false) //TEST
            )
            .clipped()//TEST
                
        }
    }
}

#Preview {
    StripedBG()
}
