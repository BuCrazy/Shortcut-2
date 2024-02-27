//
//  LearnedAtThisLevel.swift
//  Shortcut 2
//
//  Created by Pavlo Bilashchuk on 10/16/23.
//

import SwiftUI

struct LearnedAtThisLevel: View {
    @State var learnedAtThisLevel = 0
    
    @AppStorage("currentLevelSelected_key") var currentLevelSelected: String = "elementary"

    
//    let elementaryWordsStorageSource = try! JSONDecoder().decode([WordItemStruct].self, from: elementaryJsonStorage)
//    let beginnerWordsStorageSource = try! JSONDecoder().decode([WordItemStruct].self, from: beginnerJsonStorage)
//    let intermediateWordsStorageSource = try! JSONDecoder().decode([WordItemStruct].self, from: intermediateJsonStorage)
//    let advancedWordsStorageSource = try! JSONDecoder().decode([WordItemStruct].self, from: advancedJsonStorage)
//    let nativelikeWordsStorageSource = try! JSONDecoder().decode([WordItemStruct].self, from: nativelikeJsonStorage)
//    let borninenglandWordsStorageSource = try! JSONDecoder().decode([WordItemStruct].self, from: borninenglandJsonStorage)
    
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
        .padding(.horizontal, 16)
        .background(Color("mainCardBG"))
        .cornerRadius(8)
    }
}

struct LearnedAtThisLevel_Previews: PreviewProvider {
    static var previews: some View {
        LearnedAtThisLevel()
    }
}
