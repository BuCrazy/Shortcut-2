//
//  Test.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 5/6/24.
//

import SwiftUI

struct NavBar: View {
    var title = ""
    let toolBarGradient = LinearGradient(
           stops: [
           Gradient.Stop(color: Color(red: 0.06, green: 0.06, blue: 0.06), location: 0.00),
           Gradient.Stop(color: Color(red: 0.06, green: 0.06, blue: 0.06).opacity(0.98), location: 0.47),
           Gradient.Stop(color: Color(red: 0.06, green: 0.06, blue: 0.06).opacity(0.95), location: 0.55),
           Gradient.Stop(color: Color(red: 0.06, green: 0.06, blue: 0.06).opacity(0.88), location: 0.67),
           Gradient.Stop(color: Color(red: 0.06, green: 0.06, blue: 0.06).opacity(0.7), location: 0.78),
           Gradient.Stop(color: Color(red: 0.06, green: 0.06, blue: 0.06).opacity(0), location: 1.00),
           ],
           startPoint: UnitPoint(x: 0.5, y: 0),
           endPoint: UnitPoint(x: 0.5, y: 1)
           )
    
    var body: some View {
        ZStack {
            Color.clear
                .background(toolBarGradient)
              //  .blur(radius: 10)
            
            Text (title)
                .font(.largeTitle.weight(.bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 16)
        }
            .frame(height: 70)
            .frame(maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    NavBar(title: "Progress")
}
