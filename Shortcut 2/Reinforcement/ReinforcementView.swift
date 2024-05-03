//
//  ReinforcementView.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 4/29/24.
//

import SwiftUI

struct ReinforcementView: View {
    @AppStorage("currentLearningMode_key") var currentLearningMode: String = "discovery"
    var body: some View {
        VStack {
            NavigationLink(destination:    SwiperScreen(), label: {
                CTAButton(buttonText: "To Discovery")
            })
            .simultaneousGesture(TapGesture().onEnded {
                
                currentLearningMode = "discovery"
            })
        }
    }
}

#Preview {
    ReinforcementView()
}
