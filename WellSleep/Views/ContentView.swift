//
//  ContentView.swift
//  WellSleep
//
//  Created by Sketch on 2021/6/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var modelData: ModelData
    @State var user: User?
    
    var body: some View {
        ZStack {
            if modelData.me == nil || modelData.isWaitingRegisteringComplete {
                RegisterView()
            } else {
                ZStack {
                    ZStack {
                        HomeView(user: $user)
                            .hidden(modelData.tab != .home)
                        UsersView(user: $user)
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
        .sheet(item: $user) {
            user = nil
        } content: { user in
            ActivitiesView(user: user)
                .padding(.horizontal)
                .ignoresSafeArea(.container)
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
