//
//  ActivityCalendar.swift
//  Shortcut 2
//
//  Created by Pavlo Bilashchuk on 10/16/23.
//

import SwiftUI
import WrappingHStack

struct ActivityCalendarView: View {
    @ObservedObject var activityLogDataLayer: ActivityCalendar
    @AppStorage("dailyGoal_key") var dailyGoal: Int = 100
    
    private var viewModel: ActivityCalendarViewModel {
            ActivityCalendarViewModel(activityLogDataLayer: activityLogDataLayer)
        }

    var body: some View {
    
        VStack(alignment: .leading) {
           
            VStack(spacing: 20) {
              
                HStack(alignment: .top) {
                    Text("90-day activity calendar")
                        .foregroundColor(Color("MainFontColor"))
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                    Spacer()
                    Image("calendarIcon")
                        .resizable()
                        .frame(width: 32, height: 32)
                } // Header Text + Icon

                VStack { // Calendar VStack Starts
                    HStack { // Calendar HStack Starts
                        VStack(spacing: 24) {
                            Text(viewModel.getMonthName(monthsBack: 2))
                                .foregroundColor(Color("MainFontColor"))
                                .font(.system(size: 12))
                             
                            Text(viewModel.getMonthName(monthsBack: 1))
                                .foregroundColor(Color("MainFontColor"))
                                .font(.system(size: 12))
                                
                            Text(viewModel.getMonthName(monthsBack: 0))
                                .foregroundColor(Color("MainFontColor"))
                                .font(.system(size: 12))
                              
                        } // Months Names
                        
                        WrappingHStack(alignment: .leading, horizontalSpacing: 3, verticalSpacing: 3) {
                            ForEach(-89..<1) { index in
                                let dateOfTheCell = viewModel.getDateOfTheCell(for: index, currentDate: activityLogDataLayer.currentDate)
                    //            let day = viewModel.getDay(from: dateOfTheCell)
                         //       let month = viewModel.getMonth(from: dateOfTheCell)
                                let numberOfActionsThisDay = activityLogDataLayer.numberOfActionsPerDay[dateOfTheCell] ?? 0
                                let percentageOfTheHighestNumberOfActions = min(Double(numberOfActionsThisDay) / Double(dailyGoal), 1)
                                
                                
                                    var cellColor: Color {
                                        switch percentageOfTheHighestNumberOfActions {
                                        case 0.000001...0.249999:
                                            return Color("ActivityCalendar2")
                                        case 0.250000...0.499999:
                                            return Color("ActivityCalendar3")
                                        case 0.500000...0.749999:
                                            return Color("ActivityCalendar4")
                                        case 0.750000...1.000000:
                                            return Color("ActivityCalendar5")
                                        case 1.000000:
                                            return Color("ActivityCalendar5")
                                        default:
                                            return Color("ActivityCalendar1")
                                        }
                                    }

                                
                                ZStack{
                                    DaySquareView(fillColor: cellColor)
                                }
                            }
                          }
                        } // WrappingHStack Ends
                        
                    } // Calndar HStack Ends
                } // Calndar VStack Ends
                
                CalendarLegendView()
             
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 16)
            .background(Color("mainCardBG"))
//            .overlay(
//                RoundedRectangle(cornerRadius: 8)
//                    .stroke(Color("StrokeColor"), lineWidth: 2)
//            )
            .cornerRadius(8)
        }
    }

struct ActivityCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        let activityCalendar = ActivityCalendar()
        return ActivityCalendarView(activityLogDataLayer: activityCalendar)
    }
}

