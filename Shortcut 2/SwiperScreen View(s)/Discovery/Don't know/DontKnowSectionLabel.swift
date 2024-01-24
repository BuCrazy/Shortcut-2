//
//  DontKnowSectionLable.swift
//  Shortcut 2
//
//  Created by Pavlo Bilashchuk on 8/11/23.
//

import SwiftUI

struct DontKnowSectionLabel: View {
    var body: some View {
        Text("Don't Know")
            .padding(.leading, 20)
            .padding(.bottom, -4)
            .font(.system(size: 24))
            .foregroundColor(.white)
    }
}

struct DontKnowSectionLabel_Previews: PreviewProvider {
    static var previews: some View {
        DontKnowSectionLabel()
    }
}

