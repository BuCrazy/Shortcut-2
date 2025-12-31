//
//  StripedBG.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 2/28/24.
//

import SwiftUI

struct StripedBG: View {
    @State private var appeared: Bool = false
    let deviceSize = LayoutSize.current()
    var body: some View {
        ZStack {
            Color("BackgroundColor")//.ignoresSafeArea()  //TEST
                .frame(maxWidth: .infinity) //TEST
                .frame(height: deviceSize.containerHeight)
                .overlay (//TEST
            Image("stripedBG")
                .resizable()
               // .scaledToFill()
            //    .frame(height: 150)
                .allowsHitTesting(false) //TEST
               
            )
            .clipped()//TEST
                
        }
      //  .frame(height: 2000)
    }
}

extension LayoutSize {
    var containerHeight: CGFloat {
        switch self {
        case . compact:
            return 150
        case .standard:
            return 250
        case .spacious:
            return 250
        }
    }
}

#Preview {
    StripedBG()
}
