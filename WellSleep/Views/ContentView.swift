//
//  ContentView.swift
//  WellSleep
//
//  Created by Sketch on 2021/6/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        ZStack {
            if modelData.me == nil {
                RegisterView()
            } else {
                ZStack {
                    ZStack {
                        HomeView()
                            .hidden(modelData.tab != .home)
                        UsersView()
                            .hidden(modelData.tab != .friends)
                    }
                    
                    VStack {
                        Spacer()
                        
                        TabBarView()
                            .environmentObject(modelData)
                        
                        Spacer()
                            .frame(height: 24)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let modelData = ModelData()
        
        return ContentView()
            .environmentObject(modelData)
    }
}
