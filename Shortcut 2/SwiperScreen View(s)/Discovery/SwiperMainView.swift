import SwiftUI

struct SwiperMainView: View {
    
    @AppStorage("currentLevelSelected_key") var currentLevelSelected: String = "elementary"
    
    @EnvironmentObject var activityLogDataLayer: ActivityCalendar
    @EnvironmentObject var storedNewWordItemsDataLayer: storedNewWordItems
    @EnvironmentObject var storedStatesDataLayer: storedStates
    
    var body: some View {
        
        VStack{
            SwiperView()
        }
        .onAppear{
//            storedNewWordItemsDataLayer.initialWordDataLoader()
            try! activityLogDataLayer.loadDataFromJSON()
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
