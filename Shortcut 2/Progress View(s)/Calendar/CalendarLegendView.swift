//
//  CalendarLegendView.swift
//  Shortcut 2
//
//  Created by Pavlo Bilashchuk on 10/18/23.
//

import SwiftUI

struct CalendarLegendView: View {
    var body: some View {
        HStack(spacing: 4) {
            Spacer()
            Text("Less")
                .foregroundColor(Color("MainFontColor"))
                .font(.system(size: 12))
            
            DaySquareView(fillColor: Color("ActivityCalendar1"))
            
            DaySquareView(fillColor: Color("ActivityCalendar2"))
      
            DaySquareView(fillColor: Color("ActivityCalendar3"))
            
            DaySquareView(fillColor: Color("ActivityCalendar4"))

            DaySquareView(fillColor: Color("ActivityCalendar5"))

            Text("More")
                .foregroundColor(Color("MainFontColor"))
                .font(.system(size: 12))

        }
    }
}

#Preview {
    CalendarLegendView()
}
