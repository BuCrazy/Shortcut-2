//
//  Goal 1 Animation.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 8/20/24.
//

import SwiftUI

struct Goal_1_Animation: View {
    @State var topCard = 1
    @State private var words = ["Swipe Down", "Unknown Cards", "Cherry", "Date", "Elderberry", "Fig", "Grape", "Honeydew", "Iced Fruit", "Jackfruit"]
    @State private var animationTimer: Timer?
    @State private var dragTranslation: CGSize = CGSize(width: 0, height: startingOffset)
    var body: some View {
        ZStack {
        //   Color(.blue).ignoresSafeArea()
            ForEach (Array(words.prefix(2).enumerated()), id: \.offset) { index, word in
                MiniWordCard(
                    word: word,
                  //  cardColor: index == 0 ? Color("mainCardBG").opacity(0.4) : Color("secondaryAnimationCard"),
            //        applyBlur: index == 0,
                    onRemove: {},
                    //cardWidth: index == 0 ? 156 : 140,
                    shadow: index == 0 ?
                    Shadow(color: Color(red: 0.26, green: 0.64, blue: 0.38).opacity(0.3), radius: 2.5, x: 0, y: -2) :
                    //Shadow(color: .clear, radius: 0, x: 0, y: 0),
                    Shadow(color: Color(red: 0.03, green: 0.57, blue: 0.21).opacity(0.17), radius: 2, x: 0, y: 0),
                    index:  index + 1,
                    topCard: $topCard
                        
                )
               // .offset(y: index == 0 ? 0 : -8)
                .zIndex(Double(words.count - index))

            }
        }
        .onAppear {
        // Reset the topCard state when the view appears
        topCard = 1
        }
    }
}
    struct Goal_1_Animation_Previews: PreviewProvider {
        
        static var previews: some View {
            Goal_1_Animation()
                
        }
    }
