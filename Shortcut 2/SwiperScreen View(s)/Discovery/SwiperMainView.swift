import SwiftUI

struct SwiperMainView: View {
    
    @AppStorage("currentLevelSelected_key") var currentLevelSelected: String = "elementary"
    
    @EnvironmentObject var activityLogDataLayer: ActivityCalendar
    @EnvironmentObject var storedNewWordItemsDataLayer: storedNewWordItems
    @EnvironmentObject var storedStatesDataLayer: storedStates
    
    var body: some View {
        
        VStack{
            switch currentLevelSelected {
            case "elementary":
                SwiperView(discoveryWordsStorageToWorkOn: storedNewWordItemsDataLayer.elementaryWordsStorage)
            case "beginner":
                SwiperView(discoveryWordsStorageToWorkOn: storedNewWordItemsDataLayer.beginnerWordsStorage)
            case "intermediate":
                SwiperView(discoveryWordsStorageToWorkOn: storedNewWordItemsDataLayer.intermediateWordsStorage)
            default:
                SwiperView(discoveryWordsStorageToWorkOn: storedNewWordItemsDataLayer.elementaryWordsStorage)
            }
        }
        
    }
}

struct SwiperMainView_Previews: PreviewProvider {
    static var previews: some View {
        SwiperMainView()
            .environmentObject(ActivityCalendar())
            .environmentObject(storedNewWordItems())
            .environmentObject(storedStates())
    }
}
