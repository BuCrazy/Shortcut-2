//
//  ConsistencyCircle.swift
//  Shortcut 2
//
//  Created by Stas Bukreiev on 14.08.2023.
//

import SwiftUI

struct ConsistencyCircle: View {
    
    var progress: Double // A value between 0 and 1 representing the progress
    var dayLetter: String
    var isCurrentDay: Bool
    
    var letterFillColor: Color {
        if isCurrentDay == true {
            return Color("consistencyCircleWhite")
        } else {
            return Color("consistencyCircleGrey")
        }
    }
    
    @State private var trimEnd: CGFloat = 0.0
        
        var body: some View {
            ZStack {
                Circle()
                    .stroke(Color("consistencyCircleGrey"), lineWidth: 4)
                    
                Circle()
                    .trim(from: 0, to: trimEnd)
                    .stroke(Color("consistencyCircleYellow"), style: StrokeStyle(lineWidth: 3, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1)) {
                            trimEnd = progress
                        }
                    }
                    .onChange(of: progress) { //_ in
                        trimEnd = progress
                    }
                    
                Text("\(dayLetter)")
                    .font(.system(size: 16))
                    .fontWeight(.bold)
                    .foregroundColor(letterFillColor)
            }
            .frame(width: 36, height: 36)
            
        }
}

struct ConsistencyCircle_Previews: PreviewProvider {
    static var previews: some View {
        ConsistencyCircle(progress: 0.5, dayLetter: "M", isCurrentDay: false)
    }
}
