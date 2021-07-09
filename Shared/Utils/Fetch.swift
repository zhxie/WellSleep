//
//  Fetch.swift
//  WellSleep
//
//  Created by Sketch on 2021/7/8.
//

import Foundation
import SwiftyJSON

func fetchUser(id: Int, completion:@escaping (User?, Error?) -> Void) {
    do {
        var request = URLRequest(url: URL(string: String(format: WellSleepUserURL, id))!)
        request.timeoutInterval = Timeout
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(nil, error)
            } else {
                let response = response as! HTTPURLResponse
                let status = response.statusCode
                guard (200...299).contains(status) else {
                    completion(nil, error)
                    
                    return
                }
                
                if let json = try? JSON(data: data!) {
                    let status = json["status"].intValue
                    guard status >= 0 else {
                        completion(nil, error)
                        
                        return
                    }
                    
                    let user = parseUser(user: json)
                    
                    completion(user, error)
                } else {
                    completion(nil, error)
                }
            }
        }
        .resume()
    }
}

func fetchActivities(user: User, to: Int, limit: Int, completion:@escaping ([Activity]?, Error?) -> Void) {
    do {
        var request = URLRequest(url: URL(string: String(format: WellSleepActivitiesURL, user.id, to, limit))!)
        request.timeoutInterval = Timeout
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(nil, error)
            } else {
                let response = response as! HTTPURLResponse
                let status = response.statusCode
                guard (200...299).contains(status) else {
                    completion(nil, error)
                    
                    return
                }
                
                if let json = try? JSON(data: data!) {
                    let status = json["status"].intValue
                    guard status >= 0 else {
                        completion(nil, error)
                        
                        return
                    }
                    
                    var activities: [Activity] = []
                    
                    let activitiesJSON = json["activities"].arrayValue
                    for activity in activitiesJSON {
                        activities.append(parseActivity(activity: activity, user: user))
                    }
                    
                    completion(activities, error)
                } else {
                    completion(nil, error)
                }
            }
        }
        .resume()
    }
}

func fetchFollowers(id: Int, completion:@escaping ([User]?, Error?) -> Void) {
    do {
        var request = URLRequest(url: URL(string: String(format: WellSleepFollowersURL, id))!)
        request.timeoutInterval = Timeout
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(nil, error)
            } else {
                let response = response as! HTTPURLResponse
                let status = response.statusCode
                guard (200...299).contains(status) else {
                    completion(nil, error)
                    
                    return
                }
                
                if let json = try? JSON(data: data!) {
                    let status = json["status"].intValue
                    guard status >= 0 else {
                        completion(nil, error)
                        
                        return
                    }
                    
                    var users: [User] = []
                    
                    let usersJSON = json["followers"].arrayValue
                    for user in usersJSON {
                        users.append(parseUser(user: user))
                    }
                    
                    completion(users, error)
                } else {
                    completion(nil, error)
                }
            }
        }
        .resume()
    }
}

func fetchTimeline(id: Int, to: Int, limit: Int, completion:@escaping ([Activity]?, [User]?, Error?) -> Void) {
    do {
        var request = URLRequest(url: URL(string: String(format: WellSleepTimelineURL, id, to, limit))!)
        request.timeoutInterval = Timeout
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(nil, nil, error)
            } else {
                let response = response as! HTTPURLResponse
                let status = response.statusCode
                guard (200...299).contains(status) else {
                    completion(nil, nil, error)
                    
                    return
                }
                
                if let json = try? JSON(data: data!) {
                    let status = json["status"].intValue
                    guard status >= 0 else {
                        completion(nil, nil, error)
                        
                        return
                    }
                    
                    var activities: [Activity] = []
                    var users: [User] = []
                    
                    // Users (Followers)
                    let usersJSON = json["followers"].arrayValue
                    for user in usersJSON {
                        users.append(parseUser(user: user))
                    }
                    users.append(parseUser(user: json))
                    let usersDict = users.reduce([Int: User]()) { (dict, user) -> [Int: User] in
                        var dict = dict
                        
                        dict[user.id] = user
                        
                        return dict
                    }
                    
                    // Activities
                    let activitiesJSON = json["timeline"].arrayValue
                    for activity in activitiesJSON {
                        let user = usersDict[activity["author"].intValue]!
                        
                        activities.append(parseActivity(activity: activity, user: user))
                    }
                    
                    completion(activities, users, error)
                } else {
                    completion(nil, nil, error)
                }
            }
        }
        .resume()
    }
}

func parseUser(user: JSON) -> User {
    let id = user["id"].intValue
    let nickname = user["nickname"].stringValue
    
    return User(id: id, nickname: nickname)
}

func parseActivity(activity: JSON, user: User) -> Activity {
    let id = activity["id"].intValue
    let type = Activity._Type(rawValue: activity["type"].intValue)!
    let time = Date(timeIntervalSince1970: activity["time"].doubleValue / 1000)
    
    return Activity(id: id, type: type, user: user, time: time, weather: nil)
}
