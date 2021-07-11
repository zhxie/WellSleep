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
            HomeView()
            
            VStack {
                Spacer()
                
                TabBarView(checkState: $modelData.checkState) {
                    let checkState = modelData.checkState
                    
                    modelData.checkState = .loading
                    
                    switch checkState {
                    case .sleep:
                        modelData.check(type: .sleep)
                    case .wake:
                        modelData.check(type: .wake)
                    default:
                        fatalError()
                    }
                }
                
                Spacer()
                    .frame(height: 24)
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
