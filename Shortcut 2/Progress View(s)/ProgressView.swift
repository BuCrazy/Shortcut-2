import SwiftUI
import WrappingHStack



struct ScrollViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

struct ProgressView: View {
    
    // Принимаем класс ActivityCalendar из файла ProgressLogs.swift, чтобы обращаться к массивам и переменным внутри этого класса:
    
    @EnvironmentObject var activityLogDataLayer: ActivityCalendar
    @EnvironmentObject var storedNewWordItemsDataLayer: storedNewWordItems
    
    @AppStorage("dailyGoal_key") var dailyGoal: Int = 100
    @AppStorage("currentLevel_key") var currentLevel: String = "elementary"
    @AppStorage("currentLevelSelected_key") var currentLevelSelected: String = "elementary"
    @AppStorage("weeklySwipeCount") var weeklySwipeCount: Int = 1
    
    @State private var isPickerVisible = false
    @State private var selectedOption = "Option 1"
    @AppStorage("levelSwitchSheetShown_key") var levelSwitchSheetShown: Bool = false
    @AppStorage("nativeLanguageSelectedID_key") var languageCodeForUse: String = ""
    
    //NOTE: The original code
    //private lazy var viewModel = DailyConsistencyViewModel(activityLogDataLayer: activityLogDataLayer)
  
    //NOTE: Test Solution Starts
    @Binding var activeModal: ActiveModal
   // @Binding var showModal: Bool
    private var viewModel: DailyConsistencyViewModel
    
    public init(activeModal: Binding<ActiveModal>, activityLogDataLayer: ActivityCalendar) {
            self._activeModal = activeModal
            self.viewModel = DailyConsistencyViewModel(activityLogDataLayer: activityLogDataLayer)
        
        print("Successful init")
    }
    //NOTE: Test Solution Ends
    
    @State static var resetAnimationTrigger = false
    
    @State private var scrollOffset: CGFloat = 0
    @State var hasScrolled = false
    
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
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { scrollViewProxy in
            ScrollView {
                GeometryReader { proxy in
                    Color.clear
                        .preference(key: ScrollViewOffsetKey.self, value: proxy.frame(in: .named("scroll")).minY)
                }
                .frame(height: 0)
                VStack {
                    VStack(spacing: 16) {
                        
                      //  OnboardingGoals()
                       // LevelProgressView()
                        
                        Button(action: {
                            withAnimation(.spring()) {
                                self.activeModal = .learnedAtThisLevel
                            }
                            let impact = UIImpactFeedbackGenerator(style: .medium)
                            impact.impactOccurred()
                        },label: {
                            LearnedAtThisLevel()
                        }).buttonStyle(.plain)
                        
                        Button(action: {
                            withAnimation(.spring()) {
                                self.activeModal = .dailyConsistency
                            }
                            let impact = UIImpactFeedbackGenerator(style: .medium)
                            impact.impactOccurred()
                        },label: {
                            DailyConsistencyView(activityLogDataLayer: activityLogDataLayer)
                        }).buttonStyle(.plain)
                        
                        HStack(spacing: 16) {
                            Button(action: {
                                withAnimation(.spring()) {
                                    self.activeModal = .discoveredThisWeek
                                }
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                            },label: {
                                DiscoveredThisWeek(discoveredThisWeek: $weeklySwipeCount)
                            }).buttonStyle(.plain)
                            
                            Button(action: {
                                withAnimation(.spring()) {
                                    self.activeModal = .almostLearned
                                }
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                            },label: {
                                AlmostLearned()
                            }).buttonStyle(.plain)
                        }
                        
                        ActivityCalendarView(activityLogDataLayer: activityLogDataLayer)
                        
                        KnowledgeMapView()
                        
                    }
                    .padding(.horizontal, 16)
                    
                    Spacer()
                        .frame(height: 76)
                }
                
                // Панель переключения уровней
                .sheet(isPresented: $levelSwitchSheetShown) {
                    LevelSwitcherSheet(languageCodePassed: languageCodeForUse, isShortVersion: true)
                        .navigationBarHidden(true)
                        .presentationDetents([.large])
                }
                .onAppear{
                    try! activityLogDataLayer.loadDataFromJSON()
                }
                .onChange(of: activityLogDataLayer.activityLog) {/* _ in*/
                    try! activityLogDataLayer.saveDataToJSON()
                }
                .padding(.top, 20)
            }
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(ScrollViewOffsetKey.self, perform: { value in
                print("Scroll value: \(value)")
                withAnimation(.linear(duration: 0.2)) {
                    hasScrolled = value < 0
                    scrollOffset = value
                }
            })
            .safeAreaInset(edge: .top, content: {
                Color.clear.frame(height: 190)
            })
            .background(Color("BackgroundColor"))
            .overlay(
                NavigationBar(
                    title: "Progress",
                    titelColor: Color( hasScrolled ? .white : Color("mainCardBG")),
                    fontsize: interpolate(start: 34, end: 24, value: scrollOffset),//hasScrolled ? 24 : 34,
                    height: interpolate(start: 200, end: 50, value: scrollOffset), // hasScrolled ? 50 : 190,
                    trailingButton: AnyView(
                        Menu(
                            content: {
                                Button(
                                    action: {
                                        levelSwitchSheetShown.toggle()
                                    },
                                    label: {
                                        Text("Switch Level")
                                    }
                                )
                            },
                            label: {
                                Image(systemName: "ellipsis")
                                    .foregroundStyle(hasScrolled ? .white : Color("mainCardBG"))
                                    .font(.body.weight(.bold))
                            }
                        )
                    ),
                    navBarColor: interpolateColor(start: Color("navBar"), end: Color("BackgroundColor"), value: scrollOffset),
                    scrollOffset: scrollOffset
                )
            )
            //                .background(Color("BackgroundColor"))
            //                .navigationTitle(Text ("Progress")).navigationBarBackButtonHidden(false)
            //                .toolbar {
            //                    Menu(
            //                        content: {
            //                            Button(
            //                                action: {
            //                                    levelSwitchSheetShown.toggle()
            //                                },
            //                                label: {
            //                                    Text("Switch Level")
            //                                }
            //                            )
            //                        },
            //                        label: {
            //                            Button(
            //                                action: {},
            //                                label: {
            //                                        Image("more")
            //                                }
            //                            )
            //                        }
            //                    )
            //                }
                }
            }
        
        
    }
    private func interpolateColor(start: Color, end: Color, value: CGFloat) -> Color {
            let progress = min(max(value / -200, 0), 1)
            
            var startRed: CGFloat = 0
            var startGreen: CGFloat = 0
            var startBlue: CGFloat = 0
            var startAlpha: CGFloat = 0
            var endRed: CGFloat = 0
            var endGreen: CGFloat = 0
            var endBlue: CGFloat = 0
            var endAlpha: CGFloat = 0
            
            UIColor(start).getRed(&startRed, green: &startGreen, blue: &startBlue, alpha: &startAlpha)
            UIColor(end).getRed(&endRed, green: &endGreen, blue: &endBlue, alpha: &endAlpha)
            
            let red = startRed + (endRed - startRed) * progress
            let green = startGreen + (endGreen - startGreen) * progress
            let blue = startBlue + (endBlue - startBlue) * progress
            let alpha = startAlpha + (endAlpha - startAlpha) * progress
            
            return Color(red: red, green: green, blue: blue, opacity: alpha)
        }
    
    private func interpolate(start: CGFloat, end: CGFloat, value: CGFloat) -> CGFloat {
            let range = end - start
            let progress = min(max(value / -200, 0), 1) // Adjust the range and direction as needed
            return start + (range * progress)
        }
    
    
}

//NOTE: Test Preview Provider
struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        // Here you need to provide an instance of ActivityCalendar to the initializer
        let activityCalendar = ActivityCalendar()
        return ProgressView(activeModal: .constant(.none), activityLogDataLayer: activityCalendar)
            .environmentObject(activityCalendar)
            .environmentObject(storedNewWordItems())
    }
}

struct GradientBackgroundModifier: ViewModifier {
    let gradient: LinearGradient
    
    func body(content: Content) -> some View {
        ZStack {
            gradient.ignoresSafeArea(edges: .top)
            content
        }
    }
}

extension View {
    func navigationBarGradient(_ gradient: LinearGradient) -> some View {
        self.modifier(GradientBackgroundModifier(gradient: gradient))
    }
}

//NOTE: This is the original Preview_Provider that works. Use it if anthing goes wrong
//struct ProgressView_Previews: PreviewProvider {
//    static var previews: some View {
//       ProgressView()
//       .environmentObject(ActivityCalendar())
//       .environmentObject(storedNewWordItems())
//    }
//}
