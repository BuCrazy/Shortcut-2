//
//  Shortvut_2AppDraft.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 9/2/24.
//
//
//import Foundation
//import SwiftUI
//import Firebase
//class AppDelegate: NSObject, UIApplicationDelegate {
//  func application(_ application: UIApplication,
//                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//    FirebaseApp.configure()
//    return true
//  }
//}
//@main
//struct Shortcut_2_App: App {
//@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
//    
//    
//    init() {
//        setupNavigationBarAppearance()
//    }
//    var body: some Scene {
//        WindowGroup {
//            RootView()
//              .environmentObject(ActivityCalendar())
//              .environmentObject(storedNewWordItems())

//        }
//    }
//    private func setupNavigationBarAppearance() {
//        
//            let appearance = UINavigationBarAppearance()
//            appearance.configureWithOpaqueBackground()
//            appearance.backgroundColor = .none
//            appearance.shadowColor = .none
//            
//            UINavigationBar.appearance().standardAppearance = appearance
//            UINavigationBar.appearance().scrollEdgeAppearance = appearance
//            UINavigationBar.appearance().compactAppearance = appearance
//            UINavigationBar.appearance().tintColor = .white
//        }
//}
