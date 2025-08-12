//
//  LevelTabContent.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 8/11/25.
//

import SwiftUI

struct LevelTabContent: View {
   // let levelType: LevelType
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    LevelTabContent()
}

struct LevelSelectorData: Identifiable {
    var id = UUID().uuidString
    var hour: Double
    var almostLearnedWords: Double
    var animate: Bool = false
}
var level_selector_data: [LevelSelectorData] = [
    LevelSelectorData(hour: 0, almostLearnedWords: 100),
    LevelSelectorData(hour: 1, almostLearnedWords: 50),
    LevelSelectorData(hour: 4, almostLearnedWords: 20),
    LevelSelectorData(hour: 10, almostLearnedWords: 10),
    LevelSelectorData(hour: 17, almostLearnedWords: 5),
    LevelSelectorData(hour: 25, almostLearnedWords: 2),
    LevelSelectorData(hour: 40, almostLearnedWords: 1)
]
