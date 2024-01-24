//
//  LearnedAtThisLvlBadge.swift
//  Shortcut 2
//
//  Created by Pavlo Bilashchuk on 1/2/24.
//

import SwiftUI

struct LearnedAtThisLvlBadge: View {
    @State private var degrees = 180.0
    @State private var scale: CGFloat = 0.5
    
    @State var learnedAtThisLevel = 100
    @AppStorage("currentLevelSelected_key") var currentLevelSelected: String = "elementary"
    var wordsAtCurrentLevel: Int {
        switch currentLevelSelected.lowercased() {
        case "elementary":
            return 500
        case "beginner":
            return 1500
        case "intermediate":
            return 3000
        case "advanced":
            return 3500
        case "nativelike":
            return 4000
        case "borninengland":
            return 7500
        default:
            return 0
        }
    }
    var body: some View {
            VStack(alignment: .leading) {
                VStack {
                    HStack(alignment: .top) {
                        Text("Words Learned At This Level")
                            .foregroundColor(Color("MainFontColor"))
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                        Spacer()
                        
                        Image("ProgressIcons_WordsLearned")
                            .resizable()
                            .frame(width: 32, height: 32)
                    }
                    .padding(.top, 16)
                }
                Spacer()
                    .frame(height: 20)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(learnedAtThisLevel) / \(wordsAtCurrentLevel)")
                        .font(.system(size: 32))
                        .foregroundColor(Color("consistencyCircleYellow"))
                        .fontWeight(.semibold)
                    Text("Words")
                        .font(.system(size: 12))
                        .foregroundColor(Color("MainFontColor"))
                }
                .padding(.bottom, 16)
                
            }
            .frame(width: 320)
            .padding(.horizontal, 16)
            .background(Color("mainCardBG"))
            .cornerRadius(8)
            .scaleEffect(scale)
            .rotation3DEffect(.degrees(degrees), axis: (x: -1, y: 0, z: 0))
            .onAppear{
                withAnimation(.bouncy(duration: 2.0)) {
                    self.degrees += 180
                    self.scale = 1.0
                }
            }
            .onTapGesture {
                withAnimation(.bouncy(duration: 2.0)) {
                    self.degrees += 360
                }
            }
        }
    }

#Preview {
    LearnedAtThisLvlBadge()
}
