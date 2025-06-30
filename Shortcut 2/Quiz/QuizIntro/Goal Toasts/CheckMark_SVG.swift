//
//  CheckMark_SVG.swift
//  Shortcut-2
//
//  Created by Pavlo Bilashchuk on 4/24/25.
//

import SwiftUI

struct CheckSVG: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.04878*width, y: 0.57534*height))
        path.addLine(to: CGPoint(x: 0.42578*width, y: 0.93735*height))
        path.addCurve(to: CGPoint(x: 0.42759*width, y: 0.93707*height), control1: CGPoint(x: 0.42634*width, y: 0.93788*height), control2: CGPoint(x: 0.42719*width, y: 0.93775*height))
        path.addLine(to: CGPoint(x: 0.94512*width, y: 0.06164*height))
        return path
    }
}
