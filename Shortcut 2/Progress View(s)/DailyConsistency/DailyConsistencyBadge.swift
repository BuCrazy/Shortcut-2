//
//  DailyConsistencyBadge.swift
//  Shortcut 2
//
//  Created by Pavlo Bilashchuk on 1/4/24.
//

import SwiftUI
import WrappingHStack

struct DailyConsistencyBadge: View {
    @State private var degrees = 180.0
    @State private var scale: CGFloat = 0.5
    var body: some View {
        VStack {
            VStack(spacing: 20) {
                
                HStack(alignment: .top){
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Daily Consistency")
                            .foregroundColor(Color("MainFontColor"))
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                        
                        Text("Today’s Learning")
                            .foregroundColor(Color("secondaryFontColor"))
                            .font(.system(size: 12))
                    } //Header Text
                    
                    Spacer()
                    
                    Image("consistencyIcon")
                        .resizable()
                        .frame(width: 32, height: 32)
                } // Header Text + Icon
                
                
                HStack(spacing: 10) {

                    ConsistencyCircle(progress: 1.0, dayLetter: "M", isCurrentDay: false)
                    ConsistencyCircle(progress: 0.5, dayLetter: "T", isCurrentDay: false)
                    ConsistencyCircle(progress: 0.3, dayLetter: "W", isCurrentDay: false)
                    ConsistencyCircle(progress: 0.9, dayLetter: "T", isCurrentDay: false)
                    ConsistencyCircle(progress: 0.7, dayLetter: "F", isCurrentDay: false)
                    ConsistencyCircle(progress: 0.6, dayLetter: "S", isCurrentDay: false)
                    ConsistencyCircle(progress: 0.1, dayLetter: "S", isCurrentDay: true)

                }
                VStack {
                    Text("90 words to daily goal")
                            .foregroundColor(Color("secondaryFontColor"))
                            .font(.system(size: 12))
                    }
                }
            }
            .frame(width: 320)
            .padding(16)
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
     
     DailyConsistencyBadge()
}
