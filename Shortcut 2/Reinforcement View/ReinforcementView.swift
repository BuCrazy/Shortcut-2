//
//  ReinforcementView.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 5/6/24.
//

import SwiftUI

struct ReinforcementView: View {
    @AppStorage("currentLearningMode_key") var currentLearningMode: String = "reinforcement"
    
    var body: some View {
        VStack {
            Spacer()
            
            NavigationLink(destination:    SwiperScreen(), label: {
                CTAButton(buttonText: "To Discovery")
            })
            .simultaneousGesture(TapGesture().onEnded {
                
                currentLearningMode = "discovery"
            })
            Spacer()
        }
        .background(Color("dictionaryBGColor"))
        .onAppear {
            currentLearningMode = "reinforcement"
            print ("Current learning mode is \(currentLearningMode)")
        }
    }
}

#Preview {
    ReinforcementView()
}
