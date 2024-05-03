//
//  ModalStyle.swift
//  Shortcut 2
//
//  Created by Pavlo Bilashchuk on 1/4/24.
//

import Foundation
import SwiftUI
struct ModalStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.bottom, 6)
            .padding(.horizontal, 6)
            .edgesIgnoringSafeArea(.all)
            .transition(.move(edge: .bottom))
            .zIndex(1)
    }
}
//NOTE: Adding this extention for ease of use in the other files
extension View {
    func modalStyle() -> some View {
        self.modifier(ModalStyle())
    }
}
