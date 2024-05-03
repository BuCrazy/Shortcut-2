//
//  DiscoveredThisWeek.swift
//  Shortcut 2
//
//  Created by Pavlo Bilashchuk on 10/16/23.
//

import SwiftUI

struct DiscoveredThisWeek: View {
    @Binding var discoveredThisWeek: Int
    
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
        .padding(.horizontal, 16)
        .background(Color("mainCardBG"))
        .cornerRadius(8)
    }
}

struct DiscoveredThisWeek_Previews: PreviewProvider {
    static var previews: some View {
        DiscoveredThisWeek(discoveredThisWeek: .constant(1))
    }
}
