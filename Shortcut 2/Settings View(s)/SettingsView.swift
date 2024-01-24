import SwiftUI

struct SettingsView: View {
    
    @AppStorage("currentLevelSelected_key") var currentLevelSelected: String = "elementary"
    
    @AppStorage("currentLanguageSelected_key") var currentLanguageSelected: String = "ukranian"
    
    @AppStorage("nativeLanguageSelectedID_key") var languageCodeForUse: String = ""
    
    var nativeLanguageSelectedID: String {
        return languageNamesAndTheirIDs[currentLanguageSelected] ?? "not defined yet"
    }
    
    @EnvironmentObject var storedNewWordItemsDataLayer: storedNewWordItems
    
    var body: some View {
        Form{
            Picker("Level to study:", selection: $currentLevelSelected) {
                Text("Elementary").tag("elementary")
                Text("Beginner").tag("beginner")
                Text("Intermediate").tag("intermediate")
//                Text("Advanced").tag("advanced")
//                Text("Native-like").tag("nativelike")
//                Text("Born in England").tag("borninengland")
            } .pickerStyle(MenuPickerStyle())
            Picker("Native language:", selection: $currentLanguageSelected) {
                ForEach(0..<languageOptionsAsTheySound.count, id: \.self) { index in
                    Text(languageOptionsAsTheySound[index])
                        .tag(languageOptionsAsTheySound[index])
                }
            } 
            .pickerStyle(MenuPickerStyle())
            .onChange(of: currentLanguageSelected) { /*_ in*/
                UserDefaults.standard.set(currentLanguageSelected, forKey: "currentLanguageSelected_key")
                UserDefaults.standard.set(nativeLanguageSelectedID, forKey: "nativeLanguageSelectedID_key")
            }
        }
    }
}

#Preview {
    SettingsView()
}
