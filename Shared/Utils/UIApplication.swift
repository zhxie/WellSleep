//
//  UIApplication.swift
//  WellSleep
//
//  Created by Sketch on 2021/7/14.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
