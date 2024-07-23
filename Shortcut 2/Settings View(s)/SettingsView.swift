import SwiftUI
import Firebase
import FirebaseAuth
struct SettingsView: View {
    @AppStorage("currentLevelSelected_key") var currentLevelSelected: String = "elementary"
    @AppStorage("currentLanguageSelected_key") var currentLanguageSelected: String = "ukranian"
    @AppStorage("nativeLanguageSelectedID_key") var languageCodeForUse: String = ""
    var nativeLanguageSelectedID: String {
        return languageNamesAndTheirIDs[currentLanguageSelected] ?? "not defined yet"
    }
    @EnvironmentObject var storedNewWordItemsDataLayer: storedNewWordItems
    @AppStorage("levelSwitchSheetShown_key") var levelSwitchSheetShown: Bool = false
    @AppStorage("loginStatus_key") private var userIsLoggedIn: Bool = false
    @State static var resetAnimationTrigger = false
    var body: some View {
        Form{
            Group{
                Section(header: Text("SETTINGS"), content: {
//                    HStack{
//                        Button(
//                            action: {
//                                levelSwitchSheetShown.toggle()
//                            }
//                            ,label: {
//                                Text("Change your level")
//                            }
//                        )
//                    }
                    HStack{
                        Picker("Native language:", selection: $currentLanguageSelected) {
                            ForEach(0..<languageOptionsAsTheySound.count, id: \.self) { index in
                                Text(languageOptionsAsTheySound[index])
                                    .tag(languageOptionsAsTheySound[index])
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    Button("Log out") {
                        try? Auth.auth().signOut()
                        userIsLoggedIn = false
                    }
//                    Button("Save data") {
//                        storedNewWordItemsDataLayer.saveData()
//                    }
//                    Button("Load data") {
//                        if let user = storedNewWordItemsDataLayer.authManager.user {
//                            storedNewWordItemsDataLayer.loadData(for: user.uid)
//                        }
//                    }
                    Button("Clear local data") {
                        storedNewWordItemsDataLayer.elementaryBeingLearned.removeAll()
                        storedNewWordItemsDataLayer.elementaryKnewAlready.removeAll()
                        storedNewWordItemsDataLayer.elementaryWordsStorage.removeAll()
                        storedNewWordItemsDataLayer.elementaryWordsStorage = elementaryWordsStorageSource
                        try! storedNewWordItemsDataLayer.elementaryKnewAlreadySave()
                        try! storedNewWordItemsDataLayer.elementaryBeingLearnedSave()
                    }
                })
            }
            .onChange(of: currentLanguageSelected) { /*_ in*/
                UserDefaults.standard.set(currentLanguageSelected, forKey: "currentLanguageSelected_key")
                UserDefaults.standard.set(nativeLanguageSelectedID, forKey: "nativeLanguageSelectedID_key")
            }
            .sheet(isPresented: $levelSwitchSheetShown) {
                LevelSwitcherSheet(languageCodePassed: languageCodeForUse, isShortVersion: true)
                    .presentationDetents([.medium])
                    .navigationBarHidden(true)
            }
        }
    }
}
#Preview {
    SettingsView()
}
