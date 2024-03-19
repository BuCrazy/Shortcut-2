import SwiftUI
import WrappingHStack
import iPages

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
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    VStack(spacing: 16) {
                        
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
                        LevelSwitcherSheet()
                            .navigationBarHidden(true)
                            .presentationDetents([.medium])
                    }
                    .onAppear{
                        try! activityLogDataLayer.loadDataFromJSON()
                    }
                    .onChange(of: activityLogDataLayer.activityLog) {/* _ in*/
                        try! activityLogDataLayer.saveDataToJSON()
                    }
                    .padding(.top, 20)
                }
                .background(Color("BackgroundColor"))
                .navigationTitle(Text ("Progress")).navigationBarBackButtonHidden(false)
                .toolbar {
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
                            Button(
                                action: {},
                                label: {
                                        Image("more")
                                }
                            )
                        }
                    )
                }
            }

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


//NOTE: This is the original Preview_Provider that works. Use it if anthing goes wrong
//struct ProgressView_Previews: PreviewProvider {
//    static var previews: some View {
//       ProgressView()
//       .environmentObject(ActivityCalendar())
//       .environmentObject(storedNewWordItems())
//    }
//}
