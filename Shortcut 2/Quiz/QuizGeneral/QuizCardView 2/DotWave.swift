//
//  DotWave.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 6/21/25.
//

import SwiftUI
import Shiny
struct DotWave: View {
    @State var isDisabled = false
    @State var isTapped = false
    @Binding var showExample: Bool
    
    var mashGradient = LinearGradient(
        stops: [
            Gradient.Stop(color: Color(red: 0.72, green: 0.45, blue: 0.91), location: 0.00),
            Gradient.Stop(color: Color(red: 0.98, green: 0.78, blue: 0.64), location: 0.49),
            Gradient.Stop(color: Color(red: 0.98, green: 0.85, blue: 0.76), location: 1.00),
        ],
        startPoint: UnitPoint(x: 0.38, y: 0.5),
        endPoint: UnitPoint(x: 0.67, y: 0.5)
    )

    let spacing: CGFloat = 13.5
    var stackDistance: CGFloat {!isTapped ? spacing : spacing * 1.8}
    var body: some View {
        Button(action: {
            guard !isDisabled else { return }
            isTapped.toggle()
            showExample = isTapped
            // Disable the button
            isDisabled = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                           isDisabled = false
                       }

        }, label: {
                ZStack {
                    //Color.black.ignoresSafeArea()
                    VStack(spacing: stackDistance) {
                        ForEach(0..<26) { rowIndex in
                            HStack(spacing: stackDistance) {
                                ForEach(0..<24) {colIndex in
                                    
                                    Circle()
                                    //         .shiny()
                                    //.foregroundColor(mashGradient)//.opacity(isTapped ? 0.05 : 0.1)
                                       .fill(.white).opacity(isTapped ? 0.05 : 0.1)
                                        .frame(width: 3, height: 3)
                                        .animation(.spring(response: 0.4, dampingFraction: 0.4)
                                            .delay(Double(rowIndex + colIndex) * 0.02), value: isTapped
                                        )
                                }
                               
                            }
                            
                        }
                    } .background(Color(.black).opacity(0.01))
                    
                    //            ZStack {
                    //              Spacer()
                    //                Button("See example") {
                    //                    isTapped.toggle()
                    //                }
                    //                    .buttonStyle(.bordered)
                    //
                    //            }
                }
            })
        .buttonStyle(.plain)
        .allowsHitTesting(!isDisabled)

    }
}

//#Preview {
//    DotWave(, showExample: false)
//    
//}
struct DotWave_Previews: PreviewProvider {
    static var previews: some View {
        DotWave(showExample: .constant(false))
    }
}
