//
//  QuizCardView.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 2/23/24.
//

import SwiftUI

struct QuizCardView: View {
    var word: String
    var question: String
    @Binding var video: URL?
    
    var body: some View {
        ZStack(alignment: .topLeading){
            //NOTE: Quiz Card itself
            Rectangle()
                .fill(Color("mainCardBG"))
                .frame(minHeight: 173, maxHeight: 355)
                .blendMode(.luminosity)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color("mainCardBorderColor"), lineWidth: 2)
                )
                .cornerRadius(24)
            
            
            VStack(alignment: .leading) {
                
                //NOTE: Quiz Word
                Text(word)
                    .font(.system(size: 34))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.top, 16)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
                
                //NOTE: Quiz Question
                Text(question)
                    .font(.system(size: 16))
                    .fontWeight(.medium)
                    .foregroundColor(Color("SecondaryTextColor"))
                    .padding(.horizontal, 20)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer().frame(height: 32)
                
                //NOTE: Player View
                HStack{
                    if let videoURL = video {
                        PlayerView(url: videoURL/*, shouldStopVideo: $shouldStopVideo*/)
                            .frame(maxWidth: .infinity, maxHeight: 200)
                            .cornerRadius(8)
                            .edgesIgnoringSafeArea(.all)
                            .aspectRatio(contentMode: .fill)
                    }
                }
                .cornerRadius(8)
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
                .shadow(radius: 8)
            }
        }
        .padding(.horizontal, 16)
    }
}

struct QuizCard_Previews: PreviewProvider {
    static var previews: some View {
        let videoURL = URL(string: "https://www.playphrase.me/video/5b183a998079eb4cd4a595ed/628f2113b071e7f3ed0e4a41.mp4")
        QuizCardView(word: "Testla", question: "Choose correct translation of", video: Binding.constant(videoURL))
    }
}
