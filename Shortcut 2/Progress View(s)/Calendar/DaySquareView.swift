//
//  DaySquareView.swift
//  Shortcut 2
//
//  Created by Pavlo Bilashchuk on 10/18/23.
//

import SwiftUI

struct DaySquareView: View {
    var fillColor: Color
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(fillColor)
                .frame(width:16, height: 16)
                .cornerRadius(2)
        }
    }
}

struct DaySquareView_Previews: PreviewProvider {
    static var previews: some View {
        DaySquareView(fillColor: Color(.black))

    }
}
