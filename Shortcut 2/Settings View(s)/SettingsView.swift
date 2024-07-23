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
    @State var levelSwitchSheetShown: Bool = false
    @AppStorage("languageSwitchSheetShown_key") var languageSwitchSheetShown: Bool = false
    @AppStorage("loginStatus_key") private var userIsLoggedIn: Bool = false
    @State static var resetAnimationTrigger = false
    var body: some View {
        Form{
            Group{
                Section(header: Text("SETTINGS"), content: {
                    HStack{
                        Button(
                            action: {
                                levelSwitchSheetShown.toggle()
                            }
                            ,label: {
                                Text("Change your level")
                            }
                        )
                    }
                    HStack{
                        Button(
                            action: {
                                languageSwitchSheetShown.toggle()
                            }
                            ,label: {
                                Text("Change your native language")
                            }
                        )
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
        }
        .sheet(isPresented: $levelSwitchSheetShown) {
            LevelSwitcherSheet(languageCodePassed: languageCodeForUse, isShortVersion: true)
                .presentationDetents([.large])
                .navigationBarHidden(true)
        }
        .sheet(isPresented: $languageSwitchSheetShown) {
            LanguageSelectionSheet(languageCodeForUse: languageCodeForUse, isShortVersion: true)
                .navigationBarHidden(true)
                .presentationDetents([.large])
        }

    }
}
#Preview {
    SettingsView()
}
