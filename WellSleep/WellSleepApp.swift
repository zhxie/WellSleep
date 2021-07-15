//
//  WellSleepApp.swift
//  WellSleep
//
//  Created by Sketch on 2021/6/21.
//

import SwiftUI

@main
struct WellSleepApp: App {
    @StateObject var modelData = ModelData()

    var body: some Scene {
        // modelData.load()
        
        return WindowGroup {
            ContentView()
                .environmentObject(modelData)
        }
    }
}
