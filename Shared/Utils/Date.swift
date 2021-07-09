//
//  Date.swift
//  WellSleep
//
//  Created by Sketch on 2021/6/21.
//

import Foundation

extension Date {
    func formatDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d"
        
        return dateFormatter.string(from: self)
    }
    
    func formatFullDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "Y/M/d"
        
        return dateFormatter.string(from: self)
    }
    
    func formatWeekday() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        
        return dateFormatter.string(from: self).uppercased()
    }
    
    func formatTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter.string(from: self)
    }
}
