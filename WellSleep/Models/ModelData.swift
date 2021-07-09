//
//  ModelData.swift
//  WellSleep
//
//  Created by Sketch on 2021/6/21.
//

import Foundation
import SwiftUI

enum CheckState {
    case sleep
    case wake
    case loading
    
    var systemName: String {
        switch self {
        case .sleep:
            return "moon.fill"
        case .wake:
            return "circle.fill"
        case .loading:
            return "rays"
        }
    }
    
    var foregroundColor: Color {
        switch self {
        case .sleep:
            return Color(red: 231 / 255, green: 199 / 255, blue: 124 / 255)
        case .wake:
            return Color(red: 249 / 255, green: 222 / 255, blue: 162 / 255)
        case .loading:
            return .primary
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .sleep:
            return Color(red: 76 / 255, green: 91 / 255, blue: 119 / 255)
        case .wake:
            return Color(red: 161 / 255, green: 222 / 255, blue: 230 / 255)
        case .loading:
            return Color(UIColor.secondarySystemBackground)
        }
    }
}

final class ModelData: ObservableObject {
    @Published var checkState: CheckState = .loading
    
    @Published var lastUpdate = Date(timeIntervalSince1970: 0)
    
    @Published var activities: [Activity] = []
    @Published var users: [User] = []
    
    var id = 992319501
    
    var isTimelineUpdating = false
    var isUsersUpdating = false
    
    func updateTimeline(to: Int) {
        if isTimelineUpdating || isUsersUpdating {
            return
        } else {
            isTimelineUpdating = true
            isUsersUpdating = true
            
            getTimeline(id: id, to: to, limit: Limit) { activities, users, error in
                guard let activities = activities, let users = users else {
                    DispatchQueue.main.async {
                        self.isTimelineUpdating = false
                        self.isUsersUpdating = false
                    }
                    
                    return
                }
                
                let _self = users.first { user in
                    user.id == self.id
                }!
                
                getActivities(user: _self, to: 0, limit: 1) { acts, error2 in
                    guard let acts = acts else {
                        DispatchQueue.main.async {
                            self.isTimelineUpdating = false
                            self.isUsersUpdating = false
                        }
                        
                        return
                    }
                    
                    var nextCheckState: CheckState
                    if acts.isEmpty {
                        nextCheckState = .sleep
                    } else {
                        switch acts.first!.type {
                        case .sleep:
                            nextCheckState = .wake
                        case .wake:
                            nextCheckState = .sleep
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.checkState = nextCheckState
                        self.activities = activities
                        self.users = users
                        
                        self.isTimelineUpdating = false
                        self.isUsersUpdating = false
                    }
                }
            }
        }
    }
    
    func check(type: Activity._Type) {
        if isTimelineUpdating || isUsersUpdating {
            return
        } else {
            isTimelineUpdating = true
            isUsersUpdating = true
            
            postCheck(id: id, type: type) { success, error in
                guard success else {
                    DispatchQueue.main.async {
                        switch type {
                        case .sleep:
                            self.checkState = .sleep
                        case .wake:
                            self.checkState = .wake
                        }
                        
                        self.isTimelineUpdating = false
                        self.isUsersUpdating = false
                    }
                    
                    return
                }
                
                DispatchQueue.main.async {
                    self.isTimelineUpdating = false
                    self.isUsersUpdating = false
                    
                    self.updateTimeline(to: 0)
                }
            }
        }
    }
}
