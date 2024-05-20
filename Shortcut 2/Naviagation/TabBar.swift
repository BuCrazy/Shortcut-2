//
//  TabBar.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 5/16/24.
//

import SwiftUI



struct TabBar: View {
    @EnvironmentObject var activityLogDataLayer: ActivityCalendar
    @EnvironmentObject var storedNewWordItemsDataLayer: storedNewWordItems
    @EnvironmentObject var storedStatesDataLayer: storedStates
    
    @Binding var selectedTab: ContentView.Tab
   // @State private var selectedTab: Tab = .second
  //  @State var activeModal: ActiveModal = .none
    @Binding var activeModal: ActiveModal
    
    enum Tab {
        case first, second, third, fourth
    }
    
    let tabBarGradient = LinearGradient(
        stops: [
            Gradient.Stop(color: Color(red: 0.06, green: 0.06, blue: 0.06), location: 0.00),
        Gradient.Stop(color: Color(red: 0.06, green: 0.06, blue: 0.06).opacity(0.97), location: 0.57),
            Gradient.Stop(color: Color(red: 0.06, green: 0.06, blue: 0.06).opacity(0.79), location: 0.73),
        Gradient.Stop(color: Color(red: 0.06, green: 0.06, blue: 0.06).opacity(0.52), location: 0.84),
        Gradient.Stop(color: Color(red: 0.06, green: 0.06, blue: 0.06).opacity(0), location: 1.00),
        ],
        startPoint: UnitPoint(x: 0.47, y: 1),
        endPoint: UnitPoint(x: 0.47, y: 0)
        )
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            
            
            VStack{
                // Content area
                switch selectedTab {
                case .first:
                    ProgressView(activeModal: $activeModal, activityLogDataLayer: activityLogDataLayer)
                case .second:
                    SwiperScreen()
                        .environmentObject(storedNewWordItemsDataLayer)
                case .third:
                    DictionaryView(consecutiveCorrectRecalls: 0, progress: 0.0)
                case .fourth:
                    SettingsView()
                }
            }
            
          
                
            VStack {
            
                HStack {
                        TabBarItem(image: "progress", selectedImage: "progress.fill", isSelected: selectedTab == .first) {
                            selectedTab = .first
                        }
                        TabBarItem(image: "discovery", selectedImage: "discovery.fill", isSelected: selectedTab == .second) {
                            selectedTab = .second
                        }
                        TabBarItem(image: "library", selectedImage: "library.fill", isSelected: selectedTab == .third) {
                            selectedTab = .third
                        }
                        TabBarItem(image: "account", selectedImage: "account.fill", isSelected: selectedTab == .fourth) {
                            selectedTab = .fourth
                        }
                    }
                Spacer().frame(height: 34)
         //       }
                
            }.background(tabBarGradient)
        }

        
    }
}

#Preview {
    TabBar(selectedTab: .constant(.second), activeModal: .constant(.none))
        .environmentObject(ActivityCalendar())
        .environmentObject(storedNewWordItems())
        .environmentObject(storedStates())
}
