import SwiftUI

struct SwiperScreen: View {
    
    @EnvironmentObject var activityLogDataLayer: ActivityCalendar
    @EnvironmentObject var storedNewWordItemsDataLayer: storedNewWordItems
    @EnvironmentObject var storedStatesDataLayer: storedStates
    
    @AppStorage("wordsPerDiscoverySetting_key") var wordsPerDiscoverySetting: Int = 30
    @AppStorage("wordsPerRevisionSetting_key") var wordsPerRevisionSetting: Int = 30
    
    @AppStorage("wordsDiscoveredDuringTheCurrentDiscoverySession_key") var wordsDiscoveredDuringTheCurrentDiscoverySession: Int = 0
    @AppStorage("wordsDiscoveredDuringTheCurrentRevisionSession_key") var wordsDiscoveredDuringTheCurrentRevisionSession: Int = 0
    
    @AppStorage("currentLearningMode_key") var currentLearningMode: String = "discovery"
    @AppStorage("currentLevelSelected_key") var currentLevelSelected: String = "elementary"
    
    var body: some View {
        VStack{
            if currentLearningMode == "discovery" {
                SwiperMainView()
            } else if currentLearningMode == "revision" {
                QuizIntroView()
               // QuizView(storedWords: storedNewWordItemsDataLayer)
            } else if currentLearningMode == "revisionForever" {
                QuizView(storedWords: storedNewWordItemsDataLayer)
            }
        }
    }
    
}

#Preview {
    SwiperScreen()
        .environmentObject(ActivityCalendar())
        .environmentObject(storedNewWordItems())
        .environmentObject(storedStates())
}
