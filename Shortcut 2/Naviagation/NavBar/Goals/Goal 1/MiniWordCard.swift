//
//  MiniWordCard.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 8/20/24.
//

import SwiftUI
import UIKit

//Constants
let delay: Double = 0.3
var startingOffset = 0.0

struct Shadow {
    var color: Color
    var radius: CGFloat
    var x: CGFloat
    var y: CGFloat
}

struct MiniWordCard: View {
    var word: String
  //  var cardColor: Color
  //  var applyBlur: Bool
    var onRemove: () -> Void
    var shadow: Shadow?
    var index: Int
    @Binding var topCard: Int
    @State private var timer: Timer?
    @State private var dragTranslation: CGSize = CGSize(width: 0, height: startingOffset)

    
    //Note: Base Liniar Scale
    func scale(inputMin: CGFloat, inputMax: CGFloat, outputMin: CGFloat, outputMax: CGFloat, value: CGFloat) -> CGFloat {
            return outputMin + (outputMax - outputMin) * (value - inputMin) / (inputMax - inputMin)
        }
    
    // Change resting offset based on the topCard value
        func offsetScale(topCard: Int, index: Int) -> CGFloat {
            return index == topCard ? 8 : -7  // after : just -7 in origianl version
        }
    
    func sizeScale(topCard: Int, index: Int) -> CGFloat {
        return index == topCard ? 1.0 : 0.85
        }
    
    
    func performSwipe() {
           withAnimation(.easeOut(duration: delay)) {
               dragTranslation.height = 200 + startingOffset
           }

           DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
               withAnimation(.spring()) {
                   dragTranslation.height = startingOffset
                  // let oldTopCard = topCard
                   topCard = (topCard % 2) + 1 // Toggle between 1 and 2
                   
               }
           }
       }
    
    var drag: some Gesture {
            DragGesture()
                .onChanged { gesture in
                    dragTranslation.height = gesture.translation.height + startingOffset
                }
                .onEnded { gesture in
                    let predictedEndTranslation: Double = gesture.predictedEndTranslation.height

                    if predictedEndTranslation >= 150 {
                        // At the peak, update z-index
                        performSwipe()
                    } else {
                        withAnimation(.spring()) {
                            dragTranslation.height = startingOffset
                        }
                    }
                }
        }
    
    
    var body: some View {
         // Top Card
        ZStack(alignment: .topLeading) {
            Rectangle()
            //.fill(cardColor)
                .fill(index == topCard ? Color("topAnimationCard")/*Color("mainCardBG").opacity(0.4)*/ : Color("secondaryAnimationCard"))
            .frame(width: 156, height:  98)
            .animation(.spring(), value: topCard)
            .cornerRadius(6)
                    if index == topCard {
                        HStack {
                            Text(word)
                                .font(.system(size: 12))
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                        .padding(.top, 8)
                        .padding(.leading, 8)
                    }
                }
            .drawingGroup()
            .scaleEffect(sizeScale(topCard: topCard, index: index))
            .offset(y: offsetScale(topCard: topCard, index: index) + dragTranslation.height / 2) // Adjusted offset
            .padding(.horizontal, 20)
            .shadow(color: (index == topCard ? Color(red: 0.26, green: 0.64, blue: 0.38).opacity(0.3) : Color(red: 0.03, green: 0.57, blue: 0.21).opacity(0.17)),
                            radius: (index == topCard ? 2.5 : 2),
                            x: (index == topCard ? 0 : 0),
                            y: (index == topCard ? -2 : 0))
//            .shadow(color: shadow?.color ?? .clear, radius: shadow?.radius ?? 0, x: shadow?.x ?? 0, y: shadow?.y ?? 0)
            .zIndex(Double(index == topCard ? 1 : 0))
            .allowsHitTesting(false)
            .gesture(drag)
            .animation(.spring(), value: topCard)
            .onAppear {
                // Cancel any existing timer
                    timer?.invalidate()
                
                // Reset dragTranslation
                    dragTranslation = CGSize(width: 0, height: startingOffset)
                
                // Start a new timer
                timer = Timer.scheduledTimer(withTimeInterval: 3.5, repeats: true) { _ in
                    if topCard == index {
                        performSwipe()
                    }
                }
            }
            .onDisappear {
                // Cancel the timer when the view disappears
                timer?.invalidate()
            }
            .onChange(of: topCard) { newValue in
               if index == newValue {
                let width = 156 * sizeScale(topCard: newValue, index: index)
                let height = 98 * sizeScale(topCard: newValue, index: index)
                print("Top Card Width: \(width), Height: \(height)")
                }
            }
           
//            .background(
//                ZStack {
//                   if index == topCard /*&& applyBlur*/ {
//                        TransparentBlurView(removeAllFilters: true)
//                        .blur(radius: 9, opaque: true)
//                        .mask(RoundedRectangle(cornerRadius: 6)
//                        .frame(width: 156, height: 98))
//                        }
//                    }
//            )
    }
}
struct MiniWordCard_Previews: PreviewProvider {
    static var previews: some View {
        // A state variable to simulate the topCard binding
        @State var topCard = 1
        
        return MiniWordCard(
            word: "Dexterous",
          //  cardColor: Color("StrokeColor").opacity(0.1),
          //  applyBlur: true,
            onRemove: {},
            shadow: Shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5),
            index: 1,
            topCard: $topCard// Binding the topCard state variable
        )
    }
}
