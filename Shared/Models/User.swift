//
//  User.swift
//  WellSleep
//
//  Created by Sketch on 2021/6/21.
//

import Foundation
import SwiftUI

struct User : Hashable, Codable, Identifiable {
    var id: Int
    var nickname: String
    
    var color: Color {
        switch id % 6 {
        case 0:
            return Color(red: 171 / 255, green: 151 / 255, blue: 210 / 255)
        case 1:
            return Color(red: 182 / 255, green: 210 / 255, blue: 111 / 255)
        case 2:
            return Color(red: 240 / 255, green: 220 / 255, blue: 130 / 255)
        case 3:
            return Color(red: 239 / 255, green: 186 / 255, blue: 136 / 255)
        case 4:
            return Color(red: 242 / 255, green: 168 / 255, blue: 172 / 255)
        case 5:
            return Color(red: 148 / 255, green: 159 / 255, blue: 248 / 255)
        default:
            fatalError()
        }
    }
}
