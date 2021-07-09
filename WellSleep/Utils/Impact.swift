//
//  Impact.swift
//  WellSleep
//
//  Created by Sketch on 2021/7/8.
//

import Foundation
import SwiftUI

func Impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
    let impact = UIImpactFeedbackGenerator(style: style)
    impact.impactOccurred()
}
