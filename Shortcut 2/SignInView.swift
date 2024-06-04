//
//  SignInView.swift
//  Shortcut-2
//
//  Created by Stanislav on 04.06.2024.
//

import SwiftUI


struct SignInView: View {
    @AppStorage("loginStatus_key") private var userIsLoggedIn: Bool = false
    var body: some View {
        if userIsLoggedIn {
            ContentView()
        } else {
            LoginWindow()
        }
    }
}

#Preview {
    SignInView()
}
