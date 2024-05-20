import SwiftUI

@main

struct Shortcut_2_App: App {
    init() {
    setupNavigationBarAppearance()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ActivityCalendar())
                .environmentObject(storedNewWordItems())
                .environment(\.colorScheme, .dark)
        }
        
    }
    private func setupNavigationBarAppearance() {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(Color("BackgroundColor"))
            appearance.shadowColor = .clear  // This removes the bottom divider

            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
        
            UINavigationBar.appearance().tintColor = .white
        }
}
