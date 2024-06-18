import SwiftUI

enum ActiveModal {
    case none
    case learnedAtThisLevel
    case dailyConsistency
    case discoveredThisWeek
    case almostLearned
}

// commit attempt

struct ContentView: View {
    
    @EnvironmentObject var activityLogDataLayer: ActivityCalendar
    @EnvironmentObject var storedNewWordItemsDataLayer: storedNewWordItems
    @EnvironmentObject var storedStatesDataLayer: storedStates
        
   // @State private var selectedTab = 1
    
    @State var screenRefresher: Bool = false
   
    @State private var selectedTab: Tab = .second

    enum Tab {
        case first, second, third, fourth
    }

    @State private var showModal = false
    @State var activeModal: ActiveModal = .none
    
    @AppStorage("isFirstAppLaunch") var isFirstAppLaunch: Bool = true
    
    var body: some View {
        
        ZStack{

            
            // Standard Tab Bar
            
//            TabView(selection: $selectedTab) {
//                NavigationView {
//                    ProgressView(activeModal: $activeModal, activityLogDataLayer: activityLogDataLayer)
//                }
//                .tabItem{
//                    TabIconView(selectedImageName: "progress.fill", unselectedImageName: "progress", isSelected: selectedTab == 0)
//                }
//                .tag(0)
//                NavigationView{
//                    SwiperScreen()
//                }
//                .tabItem {
//                    TabIconView(selectedImageName: "discovery.fill", unselectedImageName: "discovery", isSelected: selectedTab == 1)
//                }
//                .tag(1)
//                NavigationView{
//                    DictionaryView(consecutiveCorrectRecalls: 0, progress: 0.0)
//                }
//                .tabItem {
//                    TabIconView(selectedImageName: "library.fill", unselectedImageName: "library", isSelected: selectedTab == 2)
//                }
//                .tag(2)
//                NavigationView{
//                    SettingsView()
//                }
//                .tabItem {
//                    TabIconView(selectedImageName: "account.fill", unselectedImageName: "account", isSelected: selectedTab == 3)
//                }
//                .tag(3)
//            }
            // Standard Tab Bar ends
       
            
//            ZStack(alignment: .bottomLeading) {
//                VStack{
//                    // Content area
//                    switch selectedTab {
//                    case .first:
//                        ProgressView(activeModal: $activeModal, activityLogDataLayer: activityLogDataLayer)
//                    case .second:
//                        SwiperScreen()
//                            .environmentObject(storedNewWordItemsDataLayer)
//                    case .third:
//                        DictionaryView(consecutiveCorrectRecalls: 0, progress: 0.0)
//                    case .fourth:
//                        SettingsView()
//                    }
//                }
//
//    //             Tab bar
//  //              VStack {
//                  //  Spacer()
//
//                    HStack {
//                        TabBarItem(image: "progress", selectedImage: "progress.fill", isSelected: selectedTab == .first) {
//                            selectedTab = .first
//                        }
//                        TabBarItem(image: "discovery", selectedImage: "discovery.fill", isSelected: selectedTab == .second) {
//                            selectedTab = .second
//                        }
//                        TabBarItem(image: "library", selectedImage: "library.fill", isSelected: selectedTab == .third) {
//                            selectedTab = .third
//                        }
//                        TabBarItem(image: "account", selectedImage: "account.fill", isSelected: selectedTab == .fourth) {
//                            selectedTab = .fourth
//                        }
//                    }
//
//         //       }
//              // .background(tabBarGradient)
//            }
            TabBar(selectedTab: $selectedTab, activeModal: $activeModal)
            
//            // NOTE: Conditional logic using enum to understand what modal window to show
            if activeModal == .learnedAtThisLevel {
                  Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        dismissModal()
                     }
                VStack {
                    Spacer()
                    withAnimation{
                        LearnedAtThisLvlModal(activeModal: $activeModal)
                    }
                }
                .modalStyle() //NOTE: Simple ViewModifier in a form of function to encapsulate repetative styles
            } else if activeModal == .dailyConsistency {
                Color.black.opacity(0.4)
                  .edgesIgnoringSafeArea(.all)
                  .onTapGesture {
                      dismissModal()
                   }
              VStack {
                  Spacer()
                  withAnimation{
                      DailyConsistencyModal(activeModal: $activeModal)
                  }
              }
              .modalStyle()
            } else if activeModal == .discoveredThisWeek {
                Color.black.opacity(0.4)
                  .edgesIgnoringSafeArea(.all)
                  .onTapGesture {
                      dismissModal()
                   }
                VStack {
                    Spacer()
                    withAnimation{
                        DiscoveredThisWeekModal(activeModal: $activeModal)
                    }
                }
                .modalStyle()
            } else if activeModal == .almostLearned {
                Color.black.opacity(0.4)
                  .edgesIgnoringSafeArea(.all)
                  .onTapGesture {
                      dismissModal()
                   }
                VStack {
                    Spacer()
                    withAnimation{
                        AlmostLearnedModal(activeModal: $activeModal)
                    }
                }
//                .safeAreaInset(edge: .bottom) {
//                    Color.clear.frame(height: 56)
//
//                }
                .modalStyle()
            }
            
               // .frame(height: 45)
        }
       .edgesIgnoringSafeArea(.bottom)
        
        .onAppear{
            storedNewWordItemsDataLayer.initialWordDataLoader()
            try! activityLogDataLayer.loadDataFromJSON()
            if isFirstAppLaunch {
                if let user = storedNewWordItemsDataLayer.authManager.user {
                    storedNewWordItemsDataLayer.loadData(for: user.uid)
                }
            } else {
                storedNewWordItemsDataLayer.saveData()
            }
        }
        
    }
    func dismissModal() {
        print("Modal Dismissed DiscoveryView")
            withAnimation(.easeInOut(duration: 0.5)) {
                activeModal = .none
            }
    }

}

struct TabIconView: View {
    
    let selectedImageName: String
    let unselectedImageName: String
    let isSelected: Bool
    
    var body: some View {
        Image(isSelected ? selectedImageName : unselectedImageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
    
}

struct TabBarItem: View {
    let image: String
    let selectedImage: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack {
                switch isSelected {
                case false:
                    Image(image)
                case true:
                    Image(selectedImage)
//                default:
//                    Image(image)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ContentView()
        .environmentObject(ActivityCalendar())
        .environmentObject(storedNewWordItems())
        .environmentObject(storedStates())
}

