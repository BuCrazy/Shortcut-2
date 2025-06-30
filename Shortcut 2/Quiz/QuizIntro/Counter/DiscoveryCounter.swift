//
//  DiscoveryCounter.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 2/28/24.
//

import SwiftUI

struct DiscoveryCounter: View {
    @Binding var discoveredThisWeek: Int
   
    @State var counterStartVaue = 0
    
        
//    @State var currentDiscoveredNumber: Int = 50
   // @State var discoverNumberUpdate: Int = 63
  //  @State var finalTargetValue: Int = 0
    
    @State private var appeared: Bool = false
    @State private var updateAppeared: Bool = false
    @State private var hasAnimated: Bool = false
 
    init (discoveredThisWeek: Binding<Int>) {
        self._discoveredThisWeek = discoveredThisWeek
        self._counterStartVaue = State(initialValue: max(0, discoveredThisWeek.wrappedValue - 15))
    }
    
    
    var body: some View {
        VStack{
            HStack(alignment: .bottom) {
                Text("\(counterStartVaue)")
                    .font(.system(size: 32))
                    .fontWeight(.bold)
                    .foregroundColor(Color("discoveredThisWeekViolet"))
                    .padding(.bottom, 4)
                   // .offset(x: updateAppeared ? 5 : 20)
                
//                DiscoverUpdateView()
//                    .opacity(updateAppeared ? 1 : 0)
                
            }
            Text("Words discovered this week")
                .font(.system(size: 14))
                .foregroundColor(Color("weakSecondaryDark"))
        }
        .onAppear {
            if !hasAnimated {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                    withAnimation(.easeOut(duration: 1.0)) {
                        appeared.toggle()
                    }
                    //counterStartVaue = max (0, discoveredThisWeek - 15)
//                    finalTargetValue = /*currentDiscoveredNumber*/counterStartVaue + discoveredThisWeek /*discoverNumberUpdate*/
                    incrementDiscoveryNumber()
                    
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation(.easeOut(duration: 1.0)) {
                        updateAppeared.toggle()
                    }
                }
                
            }
        }
    }
    func incrementDiscoveryNumber() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                
            if /*currentDiscoveredNumber*/ counterStartVaue < discoveredThisWeek {
                withAnimation(.linear(duration: 0.01)) {
                    /*currentDiscoveredNumber*/ counterStartVaue += 1
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                }
                incrementDiscoveryNumber()
                hasAnimated = true
            }
        }
    }
}

#Preview {
    DiscoveryCounter(discoveredThisWeek: .constant(100))
}
