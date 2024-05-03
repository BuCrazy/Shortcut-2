//
//  DiscoveredThisWeekBadge.swift
//  Shortcut 2
//
//  Created by Pavlo Bilashchuk on 1/4/24.
//

import SwiftUI

struct DiscoveredThisWeekBadge: View {
    @State private var degrees = 180.0
    @State private var scale: CGFloat = 0.5
    var discoveredThisWeek: Int = 10
    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                HStack(alignment: .top) {
                    Text("Discovered \nThis Week")
                        .foregroundColor(Color("MainFontColor"))
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                    Spacer()
                    Image("ProgressIcons_DiscoveredThisWeek")
                        .resizable()
                        .frame(width: 32, height: 32)
                }
                .padding(.top, 16)
            }
            Spacer()
                .frame(height: 32)
                
            VStack(alignment: .leading, spacing: 4) {
                Text("\(discoveredThisWeek)")
                    .font(.system(size: 32))
                    .foregroundColor(Color("discoveredThisWeekViolet"))
                    .fontWeight(.semibold)
                Text("Words")
                    .font(.system(size: 12))
                    .foregroundColor(Color("MainFontColor"))
            }
            .padding(.bottom, 16)

        }
        .frame(width: 140)
        .padding(.horizontal, 16)
        .background(Color("mainCardBG"))
        .cornerRadius(8)
        .scaleEffect(scale)
        .rotation3DEffect(.degrees(degrees), axis: (x: 0, y: -1, z: 0))
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
    DiscoveredThisWeekBadge()
}
