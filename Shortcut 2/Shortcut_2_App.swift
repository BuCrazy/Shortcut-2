import SwiftUI

@main

struct Shortcut_2_App: App {
    init() {
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ActivityCalendar())
                .environmentObject(storedNewWordItems())
                .environment(\.colorScheme, .dark)
        }
        
    }

}
