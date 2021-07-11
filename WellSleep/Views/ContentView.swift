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
            switch modelData.tab {
            case .home:
                HomeView()
            case .friends:
                EmptyView()
            }
            
            VStack {
                Spacer()
                
                TabBarView()
                    .environmentObject(modelData)
                
                Spacer()
                    .frame(height: 24)
            }
        }
        .animation(.easeInOut(duration: 0.2))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let modelData = ModelData()
        
        return ContentView()
            .environmentObject(modelData)
    }
}
