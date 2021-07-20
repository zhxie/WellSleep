//
//  ModelData.swift
//  WellSleep
//
//  Created by Sketch on 2021/6/21.
//

import Foundation
import SwiftUI
import SwiftLocation

enum Tab {
    case home
    case friends
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

enum ActivitiesUpdatingSide {
    case top
    case bottom
}

struct Configuration: Codable {
    var lastUpdate: Date
    var me: User
}

final class ModelData: ObservableObject {
    static var documentsFolder: URL {
        do {
            return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        } catch {
            fatalError("Can't find documents directory.")
        }
    }
    private static var fileURL: URL {
        return documentsFolder.appendingPathComponent("WellSleep.data")
    }
    
    @Published var tab: Tab = .home
    @Published var checkState: CheckState = .loading
    
    @Published var lastUpdate = Date(timeIntervalSince1970: 0)
    
    @Published var activities: [Activity] = []
    @Published var oldestActivityId: Int = 0
    @Published var users: [User] = []
    @Published var me: User? = nil
    @Published var isWaitingRegisteringComplete = false
    
    @Published var isRegisteringOrLoggingIn = false
    var isChecking = false
    var isAddingFriend = false
    @Published var isActivitiesUpdating = false
    @Published var activitiesUpdatingSide: ActivitiesUpdatingSide = .top
    @Published var isUsersUpdating = false
    @Published var isMeUpdating = false
    
    func updateMe() {
        if isMeUpdating {
            return
        } else {
            withAnimation {
                isMeUpdating = true
            }
            
            getUser(id: me!.id) { user, error in
                guard let user = user else {
                    DispatchQueue.main.async {
                        withAnimation {
                            self.isMeUpdating = false
                        }
                    }
                    
                    return
                }
                
                DispatchQueue.main.async {
                    withAnimation {
                        self.me = user
                        
                        self.isMeUpdating = false
                    }
                }
            }
        }
    }
    
    func updateFriends() {
        if isAddingFriend || isUsersUpdating {
            return
        } else {
            withAnimation {
                isUsersUpdating = true
            }
            
            getFollowers(id: me!.id) { users, error in
                guard let users = users else {
                    DispatchQueue.main.async {
                        withAnimation {
                            self.isUsersUpdating = false
                        }
                    }
                    
                    return
                }
                
                DispatchQueue.main.async {
                    withAnimation {
                        self.users = users
                        
                        self.isUsersUpdating = false
                    }
                }
            }
        }
    }
    
    func updateTimeline() {
        if isChecking || isActivitiesUpdating {
            return
        } else {
            withAnimation {
                activitiesUpdatingSide = .top
                isActivitiesUpdating = true
            }
            
            var currentUpdate = lastUpdate
            if let activity = activities.first {
                currentUpdate = activity.time
            }
            
            getTimeline(id: me!.id, to: 0, limit: Limit) { activities, _, error in
                guard let activities = activities else {
                    DispatchQueue.main.async {
                        withAnimation {
                            self.lastUpdate = currentUpdate
                            self.saveConfiguration()
                            
                            self.isActivitiesUpdating = false
                        }
                    }
                    
                    return
                }
                
                getActivities(user: self.me!, to: 0, limit: 1) { acts, error2 in
                    guard let acts = acts else {
                        DispatchQueue.main.async {
                            withAnimation {
                                self.lastUpdate = currentUpdate
                                self.saveConfiguration()
                                
                                self.isActivitiesUpdating = false
                            }
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
                        withAnimation {
                            if !self.isChecking {
                                self.checkState = nextCheckState
                            }
                            self.lastUpdate = currentUpdate
                            self.activities = activities
                            self.oldestActivityId = activities.last?.id ?? 0
                            self.saveConfiguration()
                            
                            self.isActivitiesUpdating = false
                        }
                    }
                }
            }
        }
    }
    
    func appendTimeline() {
        if isChecking || isActivitiesUpdating {
            return
        } else {
            withAnimation {
                activitiesUpdatingSide = .bottom
                isActivitiesUpdating = true
            }
        
            getTimeline(id: me!.id, to: oldestActivityId, limit: Limit) { activities, _, error in
                guard let activities = activities else {
                    DispatchQueue.main.async {
                        self.isActivitiesUpdating = false
                    }
                    
                    return
                }
                
                DispatchQueue.main.async {
                    self.activities.append(contentsOf: activities)
                    self.oldestActivityId = activities.last?.id ?? 0
                    
                    self.isActivitiesUpdating = false
                }
            }
        }
    }
    
    func loadConfiguration() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let data = try? Data(contentsOf: Self.fileURL) else {
                return
            }
            
            guard let configuration = try? JSONDecoder().decode(Configuration.self, from: data) else {
                fatalError("Can't decode saved user data.")
            }
            
            DispatchQueue.main.async {
                self?.lastUpdate = configuration.lastUpdate
                self?.me = configuration.me
            }
        }
    }
    
    func saveConfiguration() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let me = self?.me else {
                fatalError("Self out of scope")
            }
            
            let configuration = Configuration(lastUpdate: Date(timeIntervalSinceNow: 0), me: me)
            guard let data = try? JSONEncoder().encode(configuration) else {
                fatalError("Error encoding data")
            }
            
            do {
                let outfile = Self.fileURL
                try data.write(to: outfile)
            } catch {
                fatalError("Can't write to file")
            }
        }
    }
    
    func register(nickname: String) {
        if isRegisteringOrLoggingIn {
            return
        } else {
            withAnimation {
                isRegisteringOrLoggingIn = true
            }
            
            postRegister(nickname: nickname) { id, error in
                guard let id = id else {
                    DispatchQueue.main.async {
                        withAnimation {
                            self.isRegisteringOrLoggingIn = false
                        }
                    }
                    
                    return
                }
                
                DispatchQueue.main.async {
                    withAnimation {
                        self.isWaitingRegisteringComplete = true
                        self.me = User(id: id, nickname: nickname)
                        self.saveConfiguration()
                        
                        self.isRegisteringOrLoggingIn = false
                    }
                }
            }
        }
    }
    
    func completeRegistration() {
        withAnimation {
            isWaitingRegisteringComplete = false
        }
    }
    
    func login(id: Int) {
        if isRegisteringOrLoggingIn {
            return
        } else {
            withAnimation {
                isRegisteringOrLoggingIn = true
            }
            
            getUser(id: id) { user, error in
                guard let user = user else {
                    DispatchQueue.main.async {
                        withAnimation {
                            self.isRegisteringOrLoggingIn = false
                        }
                    }
                    
                    return
                }
                
                DispatchQueue.main.async {
                    withAnimation {
                        self.me = user
                        self.saveConfiguration()
                        
                        self.isRegisteringOrLoggingIn = false
                    }
                }
            }
        }
    }
    
    func check(type: Activity._Type) {
        if isChecking {
            return
        } else {
            isChecking = true
            
            let checkState = self.checkState
            self.checkState = .loading
            
            SwiftLocation.gpsLocation(accuracy: .city).then { result in
                if let location = result.location {
                    getWeather(lat: location.coordinate.latitude, lon: location.coordinate.longitude) { weather, error in
                        self.completeChecking(checkState: checkState, type: type, weather: weather)
                    }
                } else {
                    self.completeChecking(checkState: checkState, type: type, weather: nil)
                }
            }
            
        }
    }
    
    func completeChecking(checkState: CheckState, type: Activity._Type, weather: Activity.Weather?) {
        postCheck(id: me!.id, type: type, weather: weather) { success, error in
            guard success else {
                DispatchQueue.main.async {
                    self.checkState = checkState
                }
                
                return
            }
            
            DispatchQueue.main.async {
                self.isChecking = false
                
                self.updateTimeline()
            }
        }
    }
    
    func addFriend(id: Int) {
        if isAddingFriend {
            return
        } else {
            isAddingFriend = true
            
            postFollow(id: me!.id, followee: id) { success, error in
                guard success else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.isAddingFriend = false
                    
                    self.updateFriends()
                }
            }
        }
    }
}
