import SwiftUI
import Firebase
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
  //  FirebaseApp.configure()
    return true
  }
}
@main
struct Shortcut_2_App: App {
@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
@StateObject private var appState: AppState
    
    
    init() {
        FirebaseApp.configure()
        let storedNewWordItems = storedNewWordItems()
        let activityLog = ActivityCalendar()
        let appState = AppState(storedNewWordItems: storedNewWordItems, activityLog: activityLog)
        _appState = StateObject(wrappedValue: appState)
        setupNavigationBarAppearance()
    }
    var body: some Scene {
        WindowGroup {
            RootView()
//                .environmentObject(ActivityCalendar())
//                .environmentObject(storedNewWordItems())
                .environmentObject(appState.activityLog)
                .environmentObject(appState.storedNewWordItems)
                .environmentObject(appState)
                .environment(\.colorScheme, .dark)
                .onAppear {
                    appState.loadInitialData()
            }
        }
    }
    private func setupNavigationBarAppearance() {
        
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .none
            appearance.shadowColor = .none
            
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
            UINavigationBar.appearance().tintColor = .white
        }
}
