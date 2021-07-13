//
//  API.swift
//  WellSleep
//
//  Created by Sketch on 2021/7/8.
//

import Foundation
import SwiftyJSON

func postRegister(nickname: String, completion: @escaping (Int?, Error?) -> Void) {
    do {
        var request = URLRequest(url: URL(string: WellSleepRegisterURL)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters: [String: Any] = [
            "nickname": nickname
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        
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
                    
                    let id = json["id"].intValue
                    
                    completion(id, error)
                } else {
                    completion(nil, error)
                }
            }
        }
        .resume()
    }
}

func postUpdateProfile(id: Int, nickname: String, completion: @escaping (Bool, Error?) -> Void) {
    do {
        var request = URLRequest(url: URL(string: WellSleepUpdateProfileURL)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters: [String: Any] = [
            "id": id,
            "nickname": nickname
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(false, error)
            } else {
                let response = response as! HTTPURLResponse
                let status = response.statusCode
                guard (200...299).contains(status) else {
                    completion(false, error)
                    
                    return
                }
                
                if let json = try? JSON(data: data!) {
                    let status = json["status"].intValue
                    guard status >= 0 else {
                        completion(false, error)
                        
                        return
                    }
                    
                    completion(true, error)
                } else {
                    completion(false, error)
                }
            }
        }
        .resume()
    }
}

func postCheck(id: Int, type: Activity._Type, completion: @escaping (Bool, Error?) -> Void) {
    do {
        var request = URLRequest(url: URL(string: WellSleepCheckURL)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters: [String: Any] = [
            "id": id,
            "type": type.rawValue
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(false, error)
            } else {
                let response = response as! HTTPURLResponse
                let status = response.statusCode
                guard (200...299).contains(status) else {
                    completion(false, error)
                    
                    return
                }
                
                if let json = try? JSON(data: data!) {
                    let status = json["status"].intValue
                    guard status >= 0 else {
                        completion(false, error)
                        
                        return
                    }
                    
                    completion(true, error)
                } else {
                    completion(false, error)
                }
            }
        }
        .resume()
    }
}

func postFollow(id: Int, followee: Int, completion: @escaping (Bool, Error?) -> Void) {
    do {
        var request = URLRequest(url: URL(string: WellSleepFollowURL)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters: [String: Any] = [
            "id": id,
            "followee": followee
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(false, error)
            } else {
                let response = response as! HTTPURLResponse
                let status = response.statusCode
                guard (200...299).contains(status) else {
                    completion(false, error)
                    
                    return
                }
                
                if let json = try? JSON(data: data!) {
                    let status = json["status"].intValue
                    guard status >= 0 else {
                        completion(false, error)
                        
                        return
                    }
                    
                    completion(true, error)
                } else {
                    completion(false, error)
                }
            }
        }
        .resume()
    }
}

func postUnfollow(id: Int, followee: Int, completion: @escaping (Bool, Error?) -> Void) {
    do {
        var request = URLRequest(url: URL(string: WellSleepUnfollowURL)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters: [String: Any] = [
            "id": id,
            "followee": followee
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(false, error)
            } else {
                let response = response as! HTTPURLResponse
                let status = response.statusCode
                guard (200...299).contains(status) else {
                    completion(false, error)
                    
                    return
                }
                
                if let json = try? JSON(data: data!) {
                    let status = json["status"].intValue
                    guard status >= 0 else {
                        completion(false, error)
                        
                        return
                    }
                    
                    completion(true, error)
                } else {
                    completion(false, error)
                }
            }
        }
        .resume()
    }
}

func getUser(id: Int, completion: @escaping (User?, Error?) -> Void) {
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

func getActivities(user: User, to: Int, limit: Int, completion: @escaping ([Activity]?, Error?) -> Void) {
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

func getFollowers(id: Int, completion: @escaping ([User]?, Error?) -> Void) {
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

func getTimeline(id: Int, to: Int, limit: Int, completion: @escaping ([Activity]?, [User]?, Error?) -> Void) {
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
                    var usersDict = users.reduce([Int: User]()) { (dict, user) -> [Int: User] in
                        var dict = dict
                        
                        dict[user.id] = user
                        
                        return dict
                    }
                    let me = parseUser(user: json)
                    usersDict[me.id] = me
                    
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
