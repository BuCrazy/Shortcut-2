//
//  Greeting.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 4/14/25.
//

import SwiftUI

enum TimeOfDay {
    case morning
    case afternoon
    case evening
    case night
    
    var greeting: String {
        switch self {
        case .morning:
            return "Good Morning"
        case .afternoon:
            return "Good Afternoon"
        case .evening:
            return "Good Evening"
        case .night:
            return "Greetings, Guess Sleep’s Overrated!"
        }
    }
    
    var iconName: String {
        switch self {
        case .morning:
            return "morning"
        case .afternoon:
            return "day"
        case .evening:
            return "night"
        case .night:
            return "night"
            
        }
    }
}


struct Greeting: View {
    @State var currentTimeOfDay: TimeOfDay = .morning
    
    var message: String = "The next goal will be misterious and important..."
    
  //  Timer to check for time period changes
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
  
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .center, spacing: 4) {
                //timeOfDayIcon
                Image(determineTimeOfDay().iconName)
                    .resizable()
                    .frame(width: 32, height: 32)
                    .shadow(color: .yellow, radius: 14, x: 0, y: 4)
               // Text(timeOfDay)
                Text(determineTimeOfDay().greeting
                )
                    .font(.system(size: 16, weight: .bold))
            }
            
            Text(message)
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(Color("secondaryFontColor"))
                .padding(.leading, 8)
        }
        .onAppear{
            currentTimeOfDay = determineTimeOfDay()
        }
        .onReceive(timer) {_ in
            currentTimeOfDay = determineTimeOfDay()
            print("Current time of the day is \(currentTimeOfDay)")
        }
    }
        
    
    func determineTimeOfDay() -> TimeOfDay {
        let currentDate = Date()
        let hour = Calendar.current.component(.hour, from: currentDate)
        
        switch hour {
        case 5..<12:
            return .morning
        case 12..<18:
            return .afternoon
        case 18..<24:
            return .evening
        default:
            return .night
        }
    }
}

#Preview {
    Greeting()
}
