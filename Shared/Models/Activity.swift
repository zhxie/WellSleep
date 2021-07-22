//
//  Activity.swift
//  WellSleep
//
//  Created by Sketch on 2021/6/21.
//

import Foundation
import SwiftUI

struct Activity : Hashable, Codable {
    var id: Int
    
    var type: _Type
    enum _Type : Int, CaseIterable, Codable {
        case sleep = 0
        case wake = 1
        
        var description: LocalizedStringKey {
            switch self {
            case .sleep:
                return "sleep"
            case .wake:
                return "wake"
            }
        }
        
        var foregroundColor: Color {
            switch self {
            case .sleep:
                return Color(red: 125 / 255, green: 150 / 255, blue: 163 / 255)
            case .wake:
                return Color(red: 253 / 255, green: 244 / 255, blue: 211 / 255)
            }
        }
    }
    
    var user: User
    var time: Date
    
    var weather: Weather?
    enum Weather : Int, CaseIterable, Codable {
        case clear = 0
        case partlyCloudy = 1
        case mostlyCloudy = 2
        case cloudy = 3
        case rainy = 4
        case snowy = 5
        
        var description: LocalizedStringKey {
            switch self {
            case .clear:
                return "clear"
            case .partlyCloudy:
                return "partly_cloudy"
            case .mostlyCloudy:
                return "mostly_cloudy"
            case .cloudy:
                return "cloudy"
            case .rainy:
                return "rainy"
            case .snowy:
                return "snowy"
            }
        }
        
        var image: String {
            switch self {
            case .clear:
                return "clear"
            case .partlyCloudy, .mostlyCloudy:
                return "partly_cloudy"
            case .cloudy:
                return "cloudy"
            case .rainy:
                return "rainy"
            case .snowy:
                return "snowy"
            }
        }
        
        var lightColor: Color {
            switch self {
            case .clear:
                return Color(red: 151 / 255, green: 206 / 255, blue: 245 / 255)
            case .partlyCloudy, .mostlyCloudy:
                return Color(red: 161 / 255, green: 222 / 255, blue: 230 / 255)
            case .cloudy:
                return Color(red: 197 / 255, green: 220 / 255, blue: 221 / 255)
            case .rainy, .snowy:
                return Color(red: 193 / 255, green: 213 / 255, blue: 215 / 255)
            }
        }
        
        var darkColor: Color {
            switch self {
            case .clear:
                return Color(red: 87 / 255, green: 109 / 255, blue: 142 / 255)
            case .partlyCloudy, .mostlyCloudy, .snowy:
                return Color(red: 76 / 255, green: 91 / 255, blue: 119 / 255)
            case .cloudy:
                return Color(red: 73 / 255, green: 85 / 255, blue: 102 / 255)
            case .rainy:
                return Color(red: 51 / 255, green: 65 / 255, blue: 82 / 255)
            }
        }
    }
    
    var image: String? {
        if let weather = weather {
            switch type {
            case .sleep:
                return String(format: "%@_%@", "night", weather.image)
            case .wake:
                return String(format: "%@_%@", "day", weather.image)
            }
        } else {
            return nil
        }
    }
    
    var backgroundColor: Color {
        switch type {
        case .sleep:
            return (weather ?? .clear).darkColor
        case .wake:
            return (weather ?? .clear).lightColor
        }
    }
}
