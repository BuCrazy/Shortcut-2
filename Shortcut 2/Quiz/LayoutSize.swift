//
//  LayoutSize.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 10/27/25.
//

import Foundation
import SwiftUI


enum LayoutSize {
    case compact
    case standard
    case spacious
    
    static func current(for height: CGFloat = UIScreen.main.bounds.height) -> Self {

        switch height {
        case ...700:
            return .compact
        case 701...900:
            return .standard
        default:
            return .spacious
        }
    }
}
