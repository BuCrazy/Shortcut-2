import SwiftUI
import Firebase
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
                })
            }
            .onChange(of: currentLanguageSelected) { /*_ in*/
                UserDefaults.standard.set(currentLanguageSelected, forKey: "currentLanguageSelected_key")
                UserDefaults.standard.set(nativeLanguageSelectedID, forKey: "nativeLanguageSelectedID_key")
            }
            .sheet(isPresented: $levelSwitchSheetShown) {
                LevelSwitcherSheet()
                    .presentationDetents([.medium])
                    .navigationBarHidden(true)
            }
        }
    }
}
#Preview {
    SettingsView()
}
