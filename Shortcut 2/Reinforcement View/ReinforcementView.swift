//
//  ReinforcementView.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 5/6/24.
//

import SwiftUI

struct ReinforcementView: View {
    @AppStorage("currentLearningMode_key") var currentLearningMode: String = "reinforcement"
    @Environment(\.dismiss) private var dismiss
    @Binding var currentView: DiscoveryDesctination?
    var body: some View {
        VStack {
            Spacer()
            
//            NavigationLink(destination: SwiperScreen().onAppear{ currentLearningMode = "discovery"}, label: {
//                CTAButton(buttonText: "To Discovery") //{}
//            })
//            .simultaneousGesture(TapGesture().onEnded {
//                
//                currentLearningMode = "discovery"
//            })
            
//            Button(action: {
//                currentLearningMode = "discovery"
//           
//                 // Dismiss back to the original SwiperScreen
//                dismiss()
//            }) {
//                CTAButton(buttonText: "To Discovery")
//            }
            
            Button (action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    currentView = .swiperMain
                }
            }) {
                CTAButton(buttonText: "To Discovery")
                    .padding(.horizontal, 16)
            }
            .animation(.none, value: UUID())

            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .background(Color("dictionaryBGColor"))
        .onAppear {
            currentLearningMode = "reinforcement"
            print ("Current learning mode is \(currentLearningMode)")
        }
    }
}

#Preview {
    ReinforcementView(currentView: .constant(nil))
}
