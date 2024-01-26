//
//  DiscoveryCounter.swift
//  Shortcut 2
//
//  Created by Pavlo Bilashchuk on 1/14/24.
//

import SwiftUI

struct DiscoveryCounter: View {
    @State var currentDiscoveredNumber: Int = 50
    @State var discoverNumberUpdate: Int = 63
    @State var finalTargetValue: Int = 0
    
    @State private var appeared: Bool = false
    @State private var updateAppeared: Bool = false
    @State private var hasAnimated: Bool = false
    
    var body: some View {
        VStack{
            HStack(alignment: .bottom) {
                Text("\(currentDiscoveredNumber)")
                    .font(.system(size: 32))
                    .fontWeight(.bold)
                    .foregroundColor(Color("discoveredThisWeekViolet"))
                    .padding(.bottom, 4)
                    .offset(x: updateAppeared ? 5 : 20)
                
                DiscoverUpdateView()
                    .opacity(updateAppeared ? 1 : 0)
                
            }
            Text("Words discovered this week")
                .font(.system(size: 14))
                .foregroundColor(Color("weakSecondaryDark"))
        }
        .onAppear {
            if !hasAnimated {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    withAnimation(.easeOut(duration: 1.0)) {
                        appeared.toggle()
                    }
                    finalTargetValue = currentDiscoveredNumber + discoverNumberUpdate
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
                
            if currentDiscoveredNumber < finalTargetValue {
                withAnimation(.linear(duration: 0.01)) {
                    currentDiscoveredNumber += 1
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
    DiscoveryCounter()
}
