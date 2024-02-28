//
//  CTAButton.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 2/28/24.
//

import SwiftUI

struct CTAButton: View {
    var buttonText: String
    
    var body: some View {
        HStack {
            Text(buttonText)
                .foregroundColor(.white)
                .font(.system(size: 16))
                .fontWeight(.medium)
                .padding(.vertical, 16)
        }
        .frame(maxWidth: .infinity)
        .background(Color("mainCardBG"))
        .cornerRadius(48)
    }
}

#Preview {
    CTAButton(buttonText: "Button Name")
}
