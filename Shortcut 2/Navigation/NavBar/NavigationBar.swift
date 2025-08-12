//
//  Test.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 5/6/24.
//

import SwiftUI

struct NavigationBar: View {
    @EnvironmentObject var storedNewWordItemsDataLayer: storedNewWordItems
    @EnvironmentObject var goalsManager: GoalsManager
    @AppStorage("currentLevelSelected_key") var currentLevelSelected: String = "elementary"
    
    @State var firstGoalIsCompleted = false
    @State var feedbackColor: Color = .green
    @State private var isGoalCompleted: Bool = false
    @State private var showGoalList = false
    @State var isSheet: Bool = false
    
    var greenGradient = LinearGradient(
        stops: [
        Gradient.Stop(color: Color(red: 0.09, green: 0.09, blue: 0.09), location: 0.00),
        Gradient.Stop(color: Color(red: 0.07, green: 0.08, blue: 0.07), location: 0.21),
        Gradient.Stop(color: Color(red: 0.06, green: 0.06, blue: 0.05), location: 0.42),
        Gradient.Stop(color: Color(red: 0.05, green: 0.05, blue: 0.03), location: 0.63),
        Gradient.Stop(color: Color(red: 0.05, green: 0.05, blue: 0.03), location: 0.84),
        Gradient.Stop(color: Color(red: 0.04, green: 0.05, blue: 0.02), location: 1.00),
        ],
        startPoint: UnitPoint(x: 0, y: 0.5),
        endPoint: UnitPoint(x: 1, y: 0.5)
        )
    var redGradient = LinearGradient(
        stops: [
        Gradient.Stop(color: Color(red: 0.17, green: 0.03, blue: 0.02), location: 0.00),
        Gradient.Stop(color: Color(red: 0.17, green: 0.04, blue: 0.03), location: 0.24),
        Gradient.Stop(color: Color(red: 0.14, green: 0.05, blue: 0.04), location: 0.42),
        Gradient.Stop(color: Color(red: 0.1, green: 0.07, blue: 0.06), location: 0.67),
        Gradient.Stop(color: Color(red: 0.1, green: 0.07, blue: 0.07), location: 0.83),
        Gradient.Stop(color: Color(red: 0.09, green: 0.09, blue: 0.09), location: 1.00),
        ],
        startPoint: UnitPoint(x: 1, y: 0.5),
        endPoint: UnitPoint(x: 0, y: 0.5)
        )
    var navBarTitleColor: Color {
        goalsManager.currentGoalIndex == 0 ? Color("mainCardBG")  : Color.white
    }
    var activeBGColor: Color {
        if goalsManager.currentGoalIndex == 0 { // Test Jan 14 (switch 0 and 1 to go back)
            return Color("navBar")
        } else if goalsManager.currentGoalIndex == 1 { // Test Jan 14 (switch 0 and 1 to go back)
            return feedbackColor == .green ? Color("navBarDarkGreen") : Color("navBarDarkRed")
        } else {
            return  Color("navBar")
        }
    }
    var trailingButtonColor: Color {
        goalsManager.currentGoalIndex == 1 ? Color.white : Color("mainCardBG")
    }
    
    var title = ""
    var titlColor: Color
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
           startPoint: UnitPoint(x: 0.5, y: 0.0),
           endPoint: UnitPoint(x: 0.5, y: 1.0)
           )
    var navBarColor: Color
  //  var hasScrolled: Bool
    var scrollOffset: CGFloat
    
    init(
           title: String,
           titleColor: Color,
           fontsize: CGFloat = 34,
           height: CGFloat = 200,
           navBarColor: Color,
           scrollOffset: CGFloat,
           trailingButton: AnyView? = nil
       ) {
           self.title = title
           self.titlColor = titleColor
           self.fontsize = fontsize
           self.height = height
           self.navBarColor = navBarColor
           self.scrollOffset = scrollOffset
           self.trailingButton = trailingButton
       }
    
    @ViewBuilder
    private var currentGoalView: some View {
        if goalsManager.currentGoalIndex == 0 {
            HStack {
                Goal_1(firstGoalIsCompleted: $firstGoalIsCompleted, goalsManager: goalsManager)
                    .environmentObject(goalsManager)
                    .padding(.leading, 16)
                    .offset(y: interpolate(start: 0, end: -20, value: scrollOffset * 3))
                    .opacity(interpolate(start: 1, end: 0, value: scrollOffset * 3))
                    .animation(.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0), value: scrollOffset)
                
                Goal_1_Animation()
                    .padding(.bottom, 26)
                    .offset(y: interpolate(start: 0, end: -20, value: scrollOffset * 3))
                    .opacity(interpolate(start: 1, end: 0, value: scrollOffset * 3))
                    .animation(.easeInOut(duration: 0.3), value: scrollOffset)
            }
        } else if goalsManager.currentGoalIndex == 1  {
            
            if isGoalCompleted {
                let _ = print("🎇Second goal was completed Greeting will be displayed now")
                HStack {
                    Greeting()
                        .padding(.leading, 16)
                        .offset(y: interpolate(start: 0, end: -20, value: scrollOffset * 3))
                        .opacity(interpolate(start: 1, end: 0, value: scrollOffset * 3))
                        .animation(.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0), value: scrollOffset)
                    Spacer()
                }
            } else {
                HStack {
                    Goal_2(goalsManager: goalsManager)
                        .environmentObject(goalsManager)
                        .frame(maxWidth: UIScreen.main.bounds.width / 2)
                        .padding(.leading, 16)
                        .offset(y: interpolate(start: 0, end: -20, value: scrollOffset * 3))
                        .opacity(interpolate(start: 1, end: 0, value: scrollOffset * 3))
                        .animation(.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0), value: scrollOffset)
                    Spacer()
                    
                    
                }
            }
        }
    }
    
    
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0, style: .continuous)
                .foregroundColor(.clear)
                .background(
                    Group {
                        if goalsManager.currentGoalIndex == 1 && !isGoalCompleted {
                                Goal_2_Animation(feedbackColor: $feedbackColor)
                                    .offset(y: interpolate(start: 50, end: -20, value: scrollOffset * 3))
                                    .offset(x: 90)
                                    .opacity(interpolate(start: 1, end: 0, value: scrollOffset * 3))
                                    .animation(.easeInOut(duration: 0.3), value: scrollOffset)
                        }
                    }
                         
                )
                .background(
                    Group {
                        if goalsManager.currentGoalIndex == 1 {
                            if isGoalCompleted {
                                Image("greetingBg")
                                    .resizable()
                                    .opacity(interpolate(start: 1, end: 0, value: scrollOffset * 3))
                            } else {
                                Image("navBarNoise")
                                    .resizable()
                                    .opacity(interpolate(start: 1, end: 0, value: scrollOffset * 3))
                            }
                        }
                    }
                    
                    
                )
                .background(interpolateColor(start: activeBGColor, end: toolBarGradient, value: scrollOffset))
                .mask(
                    ZStack {
                        BottomRoundedRectangle(radius: 20, corners: [.bottomLeft, .bottomRight])
                    }
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
                    .foregroundStyle(/*navBarTitleColor*/titlColor)
                    if let trailingButton = trailingButton {
                        trailingButton
                        .frame(width: 36, height: 36)
                        .padding(.trailing, 16)
                        .padding(.top, 32)
                        .foregroundStyle(trailingButtonColor)
                        }
                }

                ZStack {
                    Button(action: {
                    isSheet = true
                    showGoalList.toggle()
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                    }) {
                        
                        currentGoalView
                    }.buttonStyle(.plain)

                }
              
//                    HStack {
//                            Goal_1()
//                                .padding(.leading, 16)
//                               // .padding(.trailing, 200)
//                                .offset(y: interpolate(start: 0, end: -20, value: scrollOffset * 3 ) /*hasScrolled ? -20 : 0*/)
//                                .opacity(interpolate(start: 1, end: 0, value: scrollOffset * 3  )/*hasScrolled ? 0 : 1*/)
//                                .animation(.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0), value: scrollOffset)
//                        
//                        Goal_1_Animation()
//                            .padding(.bottom, 26)
//                            .offset(y: interpolate(start: 0, end: -20, value: scrollOffset * 3 ))
//                            .opacity(interpolate(start: 1, end: 0, value: scrollOffset * 3  ))
//                            .animation(.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0), value: scrollOffset)
//                    }
                    .frame(height: interpolate(start: 130, end: 0, value: scrollOffset))
                    .if(goalsManager.currentGoalIndex == 0) { view in
                        view.clipShape(BottomRoundedRectangle(radius: 20, corners: [.bottomLeft, .bottomRight]))
                    }
                    
               // }
            }
            
            
        }
        
        .frame(height: height)
        .frame(maxHeight: .infinity, alignment: .top)
        .sheet(isPresented: $showGoalList) {
            GoalListView(isSheet: $isSheet)
                    .presentationDetents([.large])
        }
        .onAppear {
            isGoalCompleted = goalsManager.currentGoalIndex == 1 &&
                              goalsManager.currentGoal.status == .completed
            print("🎯 NavigationBar appeared")
            print("Current goal index in NavigationBar: \(goalsManager.currentGoalIndex)")
            print("storedItems count: \(storedNewWordItemsDataLayer.elementaryBeingLearned.count)")
            print("Goal status: \(goalsManager.currentGoal.status)")
            print("isGoalCompleted: \(isGoalCompleted)")
            
        }
        .onChange(of: goalsManager.currentGoal.status) { newStatus in
            print("🔔 Goal status changed to: \(newStatus)")
            isGoalCompleted = goalsManager.currentGoalIndex == 1 && newStatus == .completed
        }
        .onChange(of: goalsManager.currentGoalIndex) { newIndex in
            print("🔄 Goal index changed to: \(newIndex)")
            isGoalCompleted = newIndex == 1 && goalsManager.currentGoal.status == .completed
        }
       
    } //body ends
    
    
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
        let mockStoredItems = storedNewWordItems()
        let mockGoalsManager = GoalsManager(storedItems: mockStoredItems)
        
        return NavigationBar(
            title: "Progress",
            titleColor: Color("mainCardBG") ,
            navBarColor: Color("navBar"),  // Match initializer parameter order
            scrollOffset: 0,
            trailingButton: AnyView(Button(action: {
                print("Button tapped")
            }) {
                Image(systemName: "ellipsis")
                    .font(.body.weight(.bold))
            })
          //  goalsManager: mockGoalsManager //Test March 12 (uncommit to get back)
        )
        .environmentObject(mockStoredItems)
        .environmentObject(GoalsManager.shared)
    }
}

extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
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


//struct BottomClipShape: Shape {
//    func path(in rect: CGRect) -> Path {
//        var path = Path()
//        // Clip only the bottom portion of the view
//        // The clipping height is reduced by 10 pixels to leave room for shadows above the bottom edge
//        path.addRect(CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: rect.height - 20))
//        return path
//    }
//}

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
