import SwiftUI
import Combine
struct LanguageItem: Identifiable {
    var id = UUID()
    var name: String
    var code: String
    var icon: String
}
class LanguageViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var languages: [LanguageItem] = [
        LanguageItem(name: "Ukranian", code: "ukranian", icon: "🇺🇦"),
        LanguageItem(name: "Russian", code: "russian", icon: "🏳️"),
        LanguageItem(name: "Bulgarian", code: "bulgarian", icon: "🇧🇬"),
        LanguageItem(name: "Chinese", code: "chinese", icon: "🇨🇳"),
        LanguageItem(name: "Czech", code: "czech", icon: "🇨🇿"),
        LanguageItem(name: "Danish", code: "danish", icon: "🇩🇰"),
        LanguageItem(name: "Dutch", code: "dutch", icon: "🇳🇱"),
        LanguageItem(name: "Estonian", code: "estonian", icon: "🇪🇪"),
        LanguageItem(name: "Finnish", code: "finnish", icon: "🇫🇮"),
        LanguageItem(name: "French", code: "french", icon: "🇫🇷"),
        LanguageItem(name: "German", code: "german", icon: "🇩🇪"),
        LanguageItem(name: "Greek", code: "greek", icon: "🇬🇷"),
        LanguageItem(name: "Hungarian", code: "hungarian", icon: "🇭🇺"),
        LanguageItem(name: "Indonesian", code: "indonesian", icon: "🇮🇩"),
        LanguageItem(name: "Italian", code: "italian", icon: "🇮🇹"),
        LanguageItem(name: "Japanese", code: "japanese", icon: "🇯🇵"),
        LanguageItem(name: "Korean", code: "korean", icon: "🇰🇷"),
        LanguageItem(name: "Latvian", code: "latvian", icon: "🇱🇻"),
        LanguageItem(name: "Norwegian", code: "norwegian", icon: "🇳🇴"),
        LanguageItem(name: "Polish", code: "polish", icon: "🇵🇱"),
        LanguageItem(name: "Portuguese", code: "portuguese", icon: "🇵🇹"),
        LanguageItem(name: "Romanian", code: "romanian", icon: "🇷🇴"),
        LanguageItem(name: "Slovak", code: "slovak", icon: "🇸🇰"),
        LanguageItem(name: "Slovenian", code: "slovenian", icon: "🇸🇮"),
        LanguageItem(name: "Spanish", code: "spanish", icon: "🇪🇸"),
        LanguageItem(name: "Swedish", code: "swedish", icon: "🇸🇪"),
        LanguageItem(name: "Turkish", code: "turkish", icon: "🇹🇷")
        // Add more languages as needed
    ]
    var filteredLanguages: [LanguageItem] {
        if searchText.isEmpty {
            return languages
        } else {
            return languages.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
}
struct LanguageSelectionSheet: View {
    @EnvironmentObject var storedNewWordItemsDataLayer: storedNewWordItems
    @State var feedbackColor: Color = Color.clear
    @StateObject private var viewModel = LanguageViewModel()
    @AppStorage("nativeLanguageSelectedID_key") var languageCodeForUse: String = ""
    @AppStorage("languageSwitchSheetShown_key") var languageSwitchSheetShown: Bool = false
    @AppStorage("isFirstAppLaunch") var isFirstAppLaunch: Bool = true
    var isShortVersion: Bool
    var body: some View {
        NavigationStack{
            VStack {
                ZStack(alignment: .top){
                    P171_CircleAnimation(feedbackColor: feedbackColor)
                        .blendMode(.screen)
                        .blur(radius: 28)
                        .offset(y: -400)
                        .opacity(0.4)
                    VStack{
                    }
                    VStack{
                        // Заголовок и подзаголовок
                        VStack(alignment: .leading){
                            Spacer()
                                .frame(height:43)
                            Text("Your native language")
                                .font(.system(size: 32))
                                .fontWeight(.bold)
                                .foregroundStyle(Color("MainFontColor"))
                            Spacer()
                                .frame(height:8)
                            Text("This will be the language you'll see translations of English words in.")
                                .font(.system(size: 14))
                                .foregroundStyle(Color("MainFontColor"))
                            Spacer()
                                .frame(height:24)
                        }
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .padding(.top, 0)
                        .padding(.leading, 20)
                        .padding(.trailing, 16)
                        // Область списка языков
                        VStack {
                            VStack{
                                HStack{
                                    Spacer()
                                        .frame(width:16)
                                    HStack{
                                        Image(systemName: "magnifyingglass")
                                            .foregroundColor(Color("Text-secondary"))
                                        Spacer()
                                            .frame(width:6)
                                        TextField("", text: $viewModel.searchText, prompt: Text("Search").foregroundColor(Color("Text-secondary")))
                                            .font(.system(size: 17))
                                    }
                                    .padding(.vertical, 7)
                                    .padding(.horizontal, 8)
                                    .background(Color("Surface-component-parts"))
                                    .cornerRadius(4)
                                    Spacer()
                                        .frame(width:16)
                                }
                            }
                            Spacer()
                                .frame(height:28)
                            ScrollView{
                                HStack{
                                    Spacer()
                                        .frame(width:21)
                                    VStack{
                                        ForEach (viewModel.filteredLanguages) { language in
                                            // Проверяем, попали ли мы на этот экран из онбординга, или из настроек
                                            switch isShortVersion {
                                            case false:
                                                NavigationLink(destination: LevelSwitcherSheet(languageCodePassed: language.code, isShortVersion: false)) {
                                                    VStack{
                                                        Spacer()
                                                            .frame(height:15)
                                                        HStack {
                                                            Spacer()
                                                                .frame(width: 15)
                                                            Text(language.icon)
                                                            Spacer()
                                                                .frame(width: 12)
                                                            Text(language.name)
                                                                .foregroundColor(Color("Text-secondary"))
                                                                .font(.system(size: 14))
                                                                .fontWeight(.bold)
                                                            Spacer()
                                                        }
                                                        Spacer()
                                                            .frame(height:15)
                                                    }
                                                    .background(Color("Surface-component-parts"))
                                                    .cornerRadius(4)
                                                }
                                                .onTapGesture {
                                                    languageCodeForUse = language.code
                                                }
                                                Spacer()
                                                    .frame(height:16)
                                            case true:
                                                Button {
                                                    languageCodeForUse = language.code
                                                    languageSwitchSheetShown = false
                                                } label: {
                                                    VStack{
                                                        Spacer()
                                                            .frame(height:15)
                                                        HStack {
                                                            Spacer()
                                                                .frame(width: 15)
                                                            Text(language.icon)
                                                            Spacer()
                                                                .frame(width: 12)
                                                            Text(language.name)
                                                                .foregroundColor(Color("Text-secondary"))
                                                                .font(.system(size: 14))
                                                                .fontWeight(.bold)
                                                            Spacer()
                                                        }
                                                        Spacer()
                                                            .frame(height:15)
                                                    }
                                                    .background(Color("Surface-component-parts"))
                                                    .cornerRadius(4)
                                                }
                                                Spacer()
                                                    .frame(height:16)
//                                            default:
//                                                Button {
//                                                    languageCodeForUse = language.code
//                                                } label: {
//                                                    VStack{
//                                                        Spacer()
//                                                            .frame(height:15)
//                                                        HStack {
//                                                            Spacer()
//                                                                .frame(width: 15)
//                                                            Text(language.icon)
//                                                            Spacer()
//                                                                .frame(width: 12)
//                                                            Text(language.name)
//                                                                .foregroundColor(Color("Text-secondary"))
//                                                                .font(.system(size: 14))
//                                                                .fontWeight(.bold)
//                                                            Spacer()
//                                                        }
//                                                        Spacer()
//                                                            .frame(height:15)
//                                                    }
//                                                    .background(Color("Surface-component-parts"))
//                                                    .cornerRadius(4)
//                                                }
//                                                Spacer()
//                                                    .frame(height:16)
                                            }
                                        }
                                    }
                                    Spacer()
                                        .frame(width:21)
                                }
                            }
                        }
                    }
                }
                .background(Color("sheetColor"))
            }
            .onAppear{
                if isFirstAppLaunch {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        if let user = storedNewWordItemsDataLayer.authManager.user {
                            storedNewWordItemsDataLayer.loadData(for: user.uid)
                            isFirstAppLaunch = false
                            print("Database download run with a 2 second delay")
                        }
                    }
                }
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}
struct LanguageSelectionSheet_Preview: PreviewProvider {
    static var previews: some View {
        LanguageSelectionSheet(isShortVersion: false)
            .environmentObject(storedNewWordItems())
            .environmentObject(ActivityCalendar())
    }
}
