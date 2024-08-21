//
//  Test.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 5/6/24.
//

import SwiftUI

struct NavigationBar: View {
    @EnvironmentObject var storedNewWordItemsDataLayer: storedNewWordItems
    @AppStorage("currentLevelSelected_key") var currentLevelSelected: String = "elementary"
    
    var title = ""
    var titelColor: Color
    var fontsize: CGFloat = 34
    var height: CGFloat = 200
    var trailingButton: AnyView?
    let startColor = Color("navBar")
    let endColor = Color("BackgroundColor")
    let toolBarGradient = LinearGradient(
           stops: [
           Gradient.Stop(color: Color(red: 0.06, green: 0.06, blue: 0.06), location: 0.00),
           Gradient.Stop(color: Color(red: 0.06, green: 0.06, blue: 0.06).opacity(0.98), location: 0.47),
           Gradient.Stop(color: Color(red: 0.06, green: 0.06, blue: 0.06).opacity(0.95), location: 0.55),
           Gradient.Stop(color: Color(red: 0.06, green: 0.06, blue: 0.06).opacity(0.88), location: 0.67),
           Gradient.Stop(color: Color(red: 0.06, green: 0.06, blue: 0.06).opacity(0.7), location: 0.78),
           Gradient.Stop(color: Color(red: 0.06, green: 0.06, blue: 0.06).opacity(0.03), location: 1.00),
           ],
           startPoint: UnitPoint(x: 0.5, y: 0),
           endPoint: UnitPoint(x: 0.5, y: 1.0)
           )
    var navBarColor: Color
  //  var hasScrolled: Bool
    var scrollOffset: CGFloat
    
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 0, style: .continuous)
                .foregroundColor(.clear)
                .background(interpolateColor(start: startColor, end: toolBarGradient, value: scrollOffset))
                .mask(
                    BottomRoundedRectangle(radius: 20, corners: [.bottomLeft, .bottomRight])
                )
                .ignoresSafeArea()

            VStack {
                //NOTE: NavBar
                HStack {
                    Text (title)
                    .font(.system(size: fontsize))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding(.leading, 16)
                    .padding(.top, 32)
                    .foregroundStyle(titelColor)
                    if let trailingButton = trailingButton {
                        trailingButton
                        .frame(width: 36, height: 36)
                        .padding(.trailing, 16)
                        .padding(.top, 32)
                        .foregroundStyle(Color("mainCardBG"))
                        }
                    }

                
                // NOTE: Current Goal
              //  if !hasScrolled {
                    HStack {
                            Goal_1()
                                .padding(.leading, 16)
                               // .padding(.trailing, 200)
                                .offset(y: interpolate(start: 0, end: -20, value: scrollOffset * 3 ) /*hasScrolled ? -20 : 0*/)
                                .opacity(interpolate(start: 1, end: 0, value: scrollOffset * 3  )/*hasScrolled ? 0 : 1*/)
                                .animation(.easeInOut(duration: 0.3), value: scrollOffset)
                        
                        Goal_1_Animation()
                            .padding(.bottom, 26)
                            .offset(y: interpolate(start: 0, end: -20, value: scrollOffset * 3 ))
                            .opacity(interpolate(start: 1, end: 0, value: scrollOffset * 3  ))
                            .animation(.easeInOut(duration: 0.3), value: scrollOffset)
                    }
                    .clipped()
                    .frame(height: interpolate(start: 130, end: 0, value: scrollOffset) /*hasScrolled ? 0 : nil*/)
                    
               // }
            }
            
            
        }
        
        .frame(height: height)
        .frame(maxHeight: .infinity, alignment: .top)
        
    }
    
    
    private func interpolateColor(start: Color, end: LinearGradient, value: CGFloat) -> some View {
            let progress = min(max(value / -200, 0), 1)
            
            return ZStack {
                start.opacity(1.0 - progress)
                end.opacity(progress)
            }
        }
    
    private func interpolate(start: CGFloat, end: CGFloat, value: CGFloat) -> CGFloat {
            let range = end - start
            let progress = min(max(value / -100, 0), 1) // Adjust the range and direction as needed
            return start + (range * progress)
        }
}

struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar(
            title: "Progress",
            titelColor: Color("mainCardBG"),
            trailingButton: AnyView(Button(action: {
            print("Button tapped")
        }) {
            Image(systemName: "ellipsis")
                .font(.body.weight(.bold))
        }),
           navBarColor: Color("navBar"),
            //hasScrolled: false
            scrollOffset: 0
        
        )
        .environmentObject(storedNewWordItems())
    }
   
    
}



struct BottomRoundedRectangle: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}


struct BottomClipShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        // Clip only the bottom portion of the view
        // The clipping height is reduced by 10 pixels to leave room for shadows above the bottom edge
        path.addRect(CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: rect.height - 20))
        return path
    }
}

//struct NavigationBar: View {
//    var title = ""
//    let toolBarGradient = LinearGradient(
//           stops: [
//           Gradient.Stop(color: Color(red: 0.06, green: 0.06, blue: 0.06), location: 0.00),
//           Gradient.Stop(color: Color(red: 0.06, green: 0.06, blue: 0.06).opacity(0.98), location: 0.47),
//           Gradient.Stop(color: Color(red: 0.06, green: 0.06, blue: 0.06).opacity(0.95), location: 0.55),
//           Gradient.Stop(color: Color(red: 0.06, green: 0.06, blue: 0.06).opacity(0.88), location: 0.67),
//           Gradient.Stop(color: Color(red: 0.06, green: 0.06, blue: 0.06).opacity(0.7), location: 0.78),
//           Gradient.Stop(color: Color(red: 0.06, green: 0.06, blue: 0.06).opacity(0), location: 1.00),
//           ],
//           startPoint: UnitPoint(x: 0.5, y: 0),
//           endPoint: UnitPoint(x: 0.5, y: 1)
//           )
//    
//    var body: some View {
//        ZStack {
//            Color.clear
//                .background(toolBarGradient)
//              //  .blur(radius: 10)
//            
//            Text (title)
//                .font(.largeTitle.weight(.bold))
//                .frame(maxWidth: .infinity, alignment: .leading)
//            .padding(.leading, 16)
//        }
//            .frame(height: 70)
//            .frame(maxHeight: .infinity, alignment: .top)
//    }
//}
//
//#Preview {
//    NavigationBar(title: "Progress")
//}
