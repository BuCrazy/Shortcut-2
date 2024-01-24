//
//  LearnedAtThisLvlModal.swift
//  Shortcut 2
//
//  Created by Pavlo Bilashchuk on 1/2/24.
//

import SwiftUI

struct LearnedAtThisLvlModal: View {
    @Binding var activeModal: ActiveModal

    var title: String = "Learned This Week"
    var description: String = "Displays the total number of cards you've learned this current week."
    var body: some View {
        Spacer()
        VStack {
            HStack {
                Spacer()
                Button (action: {
                    withAnimation {
                        dismissModals()
                    }
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Color("closeButton"))
                })
                
            }
            .padding(.top, 20)
            .padding(.trailing, 20)
            
            Text(title)
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
                .padding(.bottom,1)
            Text(description)
                .font(.system(size: 14))
                .foregroundStyle(Color("secondaryFontColor"))
                .multilineTextAlignment(.center)
                .padding(.bottom, 42)
                .padding(.horizontal, 24)
            
            
            LearnedAtThisLvlBadge()
               // .padding(.horizontal, 24)
                .shadow(color: .black.opacity(0.24), radius: 10, x: 5.0, y: 5.0)
            
            Spacer().frame(height: 42)
        }
        .background(
            Image("LATLBgImg")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
        )
        .background(Color("modalBG"))
        
        .cornerRadius(50)
        .transition(.move(edge: .bottom))
    }
    func dismissModals() {
        print("Modal Dismissed Modal itself")
        withAnimation(.easeInOut(duration: 0.5)) {
            activeModal = .none
        }
    }
}


#Preview {

    LearnedAtThisLvlModal(activeModal: .constant(.none))
    }
    
        

