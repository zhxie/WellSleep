//
//  View.swift
//  WellSleep
//
//  Created by Sketch on 2021/7/13.
//

import Foundation
import SwiftUI

extension View {
    func hidden(_ hide: Bool) -> some View {
        opacity(hide ? 0 : 1)
    }
}
