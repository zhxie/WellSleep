//
//  Constant.swift
//  WellSleep
//
//  Created by Sketch on 2021/6/21.
//

import Foundation

let WellSleepURL = "http://sketch.name.:9355"
let WellSleepRegisterURL = WellSleepURL + "/register"
let WellSleepUpdateProfileURL = WellSleepURL + "/update_profile"
let WellSleepCheckURL = WellSleepURL + "/check"
let WellSleepFollowURL = WellSleepURL + "/follow"
let WellSleepUnfollowURL = WellSleepURL + "/unfollow"
let WellSleepUserURL = WellSleepURL + "/user?id=%d"
let WellSleepActivitiesURL = WellSleepURL + "/activities?id=%d&to=%d&limit=%d"
let WellSleepFollowersURL = WellSleepURL + "/followers?id=%d"
let WellSleepTimelineURL = WellSleepURL + "/timeline?id=%d&to=%d&limit=%d"

let Timeout = 60.0
let Limit = 100

let ActivityPlaceholder = Activity(id: 0, type: .sleep, user: User(id: 0, nickname: ""), time: Date(timeIntervalSinceNow: 0), weather: nil)
let UserPlaceholder = User(id: 0, nickname: "")
