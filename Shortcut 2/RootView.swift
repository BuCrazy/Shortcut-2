import SwiftUI
struct RootView: View {
    @AppStorage("basicOnboardingPassed_key") private var basicOnboardingPassed: Bool = false
    @AppStorage("loginStatus_key") private var userIsLoggedIn: Bool = false
    @State var onboardingBlockOpacity: Double = 1
    @State var contentBlockOpacity: Double = 0
    var body: some View {
        ZStack {
            if basicOnboardingPassed == false {
                VStack{
                    LoginWindow()
                        .opacity(onboardingBlockOpacity)
                }
            } else {
                VStack{
                    ContentView()
                        .opacity(contentBlockOpacity)
                }
                .onAppear{
                    withAnimation(.easeIn(duration: 0.5)) {
                        contentBlockOpacity = 1
                    }
                }
            }
        }
        .onChange(of:basicOnboardingPassed) {
            withAnimation(.easeIn(duration: 0.5)) {
                onboardingBlockOpacity = 0
                contentBlockOpacity = 1
            }
        }
    }
}
struct RootView_Preview: PreviewProvider {
    static var previews: some View {
        RootView()
            .environmentObject(storedNewWordItems())
            .environmentObject(ActivityCalendar())
    }
}
