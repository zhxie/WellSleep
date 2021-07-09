//
//  Shape.swift
//  WellSleep
//
//  Created by Sketch on 2021/7/10.
//

import Foundation
import SwiftUI

struct Sector: Shape {
    var start: Angle
    var end: Angle
    
    var animatableData: Double {
        get { end.degrees }
        set { self.end = .degrees(newValue) }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        path.move(to: center)
        path.addArc(center: center, radius: rect.midX, startAngle: start, endAngle: end, clockwise: false)
        return path
    }
}
