//
//  ModelData.swift
//  WellSleep
//
//  Created by Sketch on 2021/6/21.
//

import Foundation
import SwiftUI

enum Tab {
    case home
    case friends
    
    var activeForegroundColor: Color {
        Color(red: 245 / 255, green: 229 / 255, blue: 151 / 255)
    }
    
    var inactiveForegroundColor: Color {
        Color(UIColor.white)
    }
    
    var backgroundColor: Color {
        Color(red: 134 / 255, green: 198 / 255, blue: 203 / 255)
    }
}

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
    @Published var tab: Tab = .home
    @Published var checkState: CheckState = .sleep
    func lock() -> CheckState? {
        if self.checkState == .loading {
            return nil
        }
        
        let checkState = self.checkState
        
        if self.checkState == .loading {
            return nil
        }
        
        self.checkState = .loading
        return checkState
    }
    
    @Published var lastUpdate = Date(timeIntervalSince1970: 0)
    
    @Published var activities: [Activity] = []
    @Published var users: [User] = []
    @Published var me = User(id: 992319501, nickname: "")
    
    func updateFriends() {
        guard let checkState = lock() else {
            return
        }
        
        getFollowers(id: me.id) { users, error in
            guard let users = users else {
                DispatchQueue.main.async {
                    self.checkState = checkState
                }
                
                return
            }
            
            DispatchQueue.main.async {
                self.users = users
                
                self.checkState = checkState
            }
        }
    }
    
    func updateTimeline(to: Int) {
        guard let checkState = lock() else {
            return
        }
        
        var currentUpdate = lastUpdate
        if let activity = activities.first {
            currentUpdate = activity.time
        }
        
        getTimeline(id: me.id, to: to, limit: Limit) { activities, users, error in
            guard let activities = activities, let users = users else {
                DispatchQueue.main.async {
                    self.checkState = checkState
                }
                
                return
            }
            
            let me = users.first { user in
                user.id == self.me.id
            }!
            
            getActivities(user: me, to: 0, limit: 1) { acts, error2 in
                guard let acts = acts else {
                    DispatchQueue.main.async {
                        self.checkState = checkState
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
                    self.lastUpdate = currentUpdate
                    self.activities = activities
                    self.users = users
                    self.me = me
                    
                    self.checkState = nextCheckState
                }
            }
        }
    }
    
    func check(type: Activity._Type) {
        guard let checkState = lock() else {
            return
        }
        
        postCheck(id: me.id, type: type) { success, error in
            guard success else {
                DispatchQueue.main.async {
                    self.checkState = checkState
                }
                
                return
            }
            
            DispatchQueue.main.async {
                self.checkState = checkState
                
                self.updateTimeline(to: 0)
            }
        }
    }
}
