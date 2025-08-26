//
//  QuizCardVIew2.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 6/21/25.
//

import SwiftUI

struct QuizCardVIew2: View {
    @State private var showExample = false
    @State private var animationTrigger = false

    var word: String
    var question: String = "What is the translation of this word?"
    var example: String = "The dexterous surgeon skillfully performed the intricate procedure with precision and ease."
    
    
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            //NOTE: Quiz Card itself
            ZStack(alignment: .bottom) {
                Rectangle()
                    .fill(Color("Surface-component-primary"))
                    .frame(minHeight: 173, maxHeight: 355)
                    .blendMode(.luminosity)
                
                VStack(alignment: .leading, spacing: 48) {
                    VStack(alignment: .leading, spacing: 4) {
                        //NOTE: Quiz Question
                        Text(question)
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                            .foregroundColor(Color("secondaryFontColor"))
                            .padding(.top, 20)
                          //  .padding(.bottom, 0.15)
                            .padding(.horizontal, 16)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        //NOTE: Quiz Word
                        Text(word)
                            .font(.system(size: 34))
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            
                       // Spacer().frame(height: 32)
                    }
                    
                    //NOTE: Interactive bottom half of card
                    ZStack(alignment: .center) {
                        Rectangle()
                            .fill(Color("sheetColor"))
                            .frame(minHeight: 173, maxHeight: 210)
                            .padding(.horizontal, 2)
                            .padding(.bottom, 1)
                            .overlay {
                                DotWave(showExample: $showExample)
                            }
                            .clipShape(Rectangle())
                        
                        CustomAnimatedText(text: example, animationType: .scaleByLetter, animationTrigger: $animationTrigger)
                            .font(.system(size: 16, design: .serif))
                            .fontWeight(.regular)
                            .foregroundColor(Color("secondaryFontColor"))
                            .opacity(showExample ? 1 : 0)
                            .animation(showExample ? .easeInOut(duration: 0.3).delay(0.5)/*, value: showExample*/ : .easeInOut(duration: 0.25).delay(0.15)/*, value: showExample*/)
                            .padding(.horizontal, 16)
                        
                    }
                   
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color("mainCardBorderColor"), lineWidth: 2)
            )
            .cornerRadius(24)
            .onChange(of: showExample) { _, newValue in
                animationTrigger = newValue
            }

            //Header (Question + Word)
//            VStack(alignment: .leading, spacing: 4) {
//                //NOTE: Quiz Question
//                Text(question)
//                    .font(.system(size: 16))
//                    .fontWeight(.medium)
//                    .foregroundColor(Color("secondaryFontColor"))
//                    .padding(.top, 20)
//                  //  .padding(.bottom, 0.15)
//                    .padding(.horizontal, 16)
//                    .fixedSize(horizontal: false, vertical: true)
//                
//                //NOTE: Quiz Word
//                Text(word)
//                    .font(.system(size: 34))
//                    .fontWeight(.semibold)
//                    .foregroundColor(.white)
//                    .padding(.horizontal, 16)
//                    
//                //Spacer().frame(height: 32)
//            }
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    QuizCardVIew2(word: "Dexterous")
}

/* QuizCardVIew2(word: quizItems[currentQuizIndex].quizWord)
 
 
 */
