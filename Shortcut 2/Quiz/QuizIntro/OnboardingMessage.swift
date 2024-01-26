//
//  OnboardingMessage.swift
//  Shortcut 2
//
//  Created by Pavlo Bilashchuk on 1/14/24.
//

import SwiftUI

struct OnboardingMessage: View {
    var headline: String = "You’ve completed your word-discovery session for now!"
    var bodyText: String = "Now we are going to practice some of the words you previously marked as unknown."
    
    var body: some View {
        VStack(alignment: .center) {
            
            Text(headline)
                .font(.system(size: 24))
                .foregroundColor(.white)
                .fontWeight(.medium)
                .padding(.bottom,8)
                .multilineTextAlignment(.center)
            
            Text(bodyText)
                .font(.system(size: 14))
                .foregroundColor(Color("weakSecondaryDark"))
                .multilineTextAlignment(.center)
            
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    OnboardingMessage()
}
