//
//  DailyConsistencyView.swift
//  Shortcut 2
//
//  Created by Pavlo Bilashchuk on 10/18/23.
//

import SwiftUI
import WrappingHStack

struct DailyConsistencyView: View {
    @ObservedObject var activityLogDataLayer: ActivityCalendar
    private var viewModel: DailyConsistencyViewModel {
            DailyConsistencyViewModel(activityLogDataLayer: activityLogDataLayer)
        }
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
                
                
                HStack {
                    ForEach(viewModel.activityLogDataLayer.getDatesWithDayNames(), id: \.id) { dayInfo in
                        let progress = viewModel.circleProgress(for: dayInfo.date)
                        let isCurrent = viewModel.isCurrentDay(date: dayInfo.date)

                        ConsistencyCircle(progress: progress, dayLetter: "\(dayInfo.dayName)", isCurrentDay: isCurrent)
                        
                        Spacer()

                    }
                }
                VStack {
                    Text(viewModel.dailyGoalMessage)
                            .foregroundColor(Color("secondaryFontColor"))
                            .font(.system(size: 12))
                    }
                }
            }
            .padding(16)
            .background(Color("mainCardBG"))
            .cornerRadius(8)

        }

        
    }
//}

struct DailyConsistencyView_Previews: PreviewProvider {
    static var previews: some View {
        let dataLayer = ActivityCalendar()
        return DailyConsistencyView(activityLogDataLayer: dataLayer)
    }
}
