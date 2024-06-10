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
                //NOTE: Check if the quiz is in progress
                if storedNewWordItemsDataLayer.isQuizInProgress() {
                    //NOTE: If a quiz is in progress, skip the QuizIntroView
                    QuizView(storedWords: storedNewWordItemsDataLayer)
                    } else {
                        QuizIntroView(storedNewWordItemsDataLayer: _storedNewWordItemsDataLayer)
                    }
            } else if currentLearningMode == "revisionForever" {
                QuizView(storedWords: storedNewWordItemsDataLayer)
            } else if currentLearningMode == "reinforcement" {
                //NOTE: Otherwise, show the QuizIntroView as usual
                  ReinforcementView()
              }
        }
        .onAppear{
//            storedNewWordItemsDataLayer.initialWordDataLoader()
            try! activityLogDataLayer.loadDataFromJSON()
        }
    }
    
}

#Preview {
    SwiperScreen()
        .environmentObject(ActivityCalendar())
        .environmentObject(storedNewWordItems())
        .environmentObject(storedStates())
}
