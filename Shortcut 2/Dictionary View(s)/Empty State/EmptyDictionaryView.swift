//
//  EmptyDictionaryView.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 7/13/25.
//

import SwiftUI

struct EmptyDictionaryView: View {
    let title: String = "Your dictionary is empty"
    let message: String = "Start by swiping cards on the Discovery page"
    
    @State private var iconOffset: CGFloat = 20
    @State private var iconOpacity: Double = 0
    @State private var copyOffset: CGFloat = 10
    @State private var copyOpacity: Double = 0
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                EmptyStateIcon(feedbackColor: .clear)
                    .offset(y: iconOffset)
                    .opacity(iconOpacity)
                    
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.8)) {
                            iconOffset = 0
                            iconOpacity = 1
                        }
                    }
                
                VStack(spacing: 4) {
                    Text(title)
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .offset(y: copyOffset)
                        .opacity(copyOpacity)
                    
                    Text(message)
                        .font(.system(size: 12))
                        .fontWeight(.regular)
                        .foregroundColor(.white).opacity(0.8)
                        .multilineTextAlignment(.center)
                        .offset(y: copyOffset)
                        .opacity(copyOpacity)
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.easeInOut(duration: 0.8)) {
                            copyOffset = 0
                            copyOpacity = 1
                        }
                    }
                }
            }
            
        }
        //Remove these modifiers when about to reaaly use this view
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color("dictionaryBGColor"))
    }
}

#Preview {
    EmptyDictionaryView()
}
