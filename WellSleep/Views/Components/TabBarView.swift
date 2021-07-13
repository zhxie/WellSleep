//
//  TabBarView.swift
//  WellSleep
//
//  Created by Sketch on 2021/7/5.
//

import SwiftUI

struct TabBarView: View {
    @EnvironmentObject var modelData: ModelData
    
    @GestureState var checkOnTapped = false
    
    var body: some View {
        let checkTap = LongPressGesture(minimumDuration: 2.0, maximumDistance: 38.4)
            .updating($checkOnTapped) { currentstate, gestureState, _ in
                gestureState = currentstate
                Impact(style: .light)
            }
            .onEnded { value in
                Impact(style: .medium)
                
                switch modelData.checkState {
                case .sleep:
                    modelData.check(type: .sleep)
                case .wake:
                    modelData.check(type: .wake)
                default:
                    fatalError()
                }
            }
        
        return HStack {
            ZStack {
                Circle()
                    .foregroundColor(Tab.home.backgroundColor)
                    .shadow(color: .black.opacity(0.15), radius: 2)
                
                Image(systemName: "house.fill")
                    .font(.headline)
                    .foregroundColor(modelData.tab == .home ? Tab.home.activeForegroundColor : Tab.home.inactiveForegroundColor)
                    .animation(.easeInOut(duration: 0.2))
            }
            .frame(width: 40, height: 40)
            .animation(.easeInOut(duration: 0.2))
            .onTapGesture {
                Impact(style: .light)
                modelData.tab = .home
            }
            
            Spacer()
                .frame(width: 16)
            
            ZStack {
                ZStack {
                    Sector(start: .degrees(-90), end: .degrees(checkOnTapped ? 270 : -90))
                        .foregroundColor(Color(UIColor.secondarySystemBackground).opacity(0.75))
                        .animation(checkOnTapped ? .linear(duration: 2.0) : .linear(duration: 0))
                }
                .scaleEffect(checkOnTapped && !isLoading ? 1.8 : 1.0)
                .animation(.easeInOut(duration: 0.2))
                
                ZStack {
                    Circle()
                        .foregroundColor(modelData.checkState.backgroundColor)
                        .shadow(color: .black.opacity(0.15), radius: 4)
                    
                    switch modelData.checkState {
                    case .sleep, .wake:
                        Image(systemName: modelData.checkState.systemName)
                            .font(.title2)
                            .foregroundColor(modelData.checkState.foregroundColor)
                    case .loading:
                        ProgressView()
                            .scaleEffect(1.5)
                    }
                }
                .scaleEffect(checkOnTapped && modelData.checkState != .loading ? 1.2 : 1.0)
                .disabled(modelData.checkState == .loading)
                .animation(.easeInOut(duration: 0.2))
                .gesture(checkTap)
            }
            .frame(width: 64, height: 64)
            
            Spacer()
                .frame(width: 16)
            
            ZStack {
                Circle()
                    .foregroundColor(Tab.friends.backgroundColor)
                    .shadow(color: .black.opacity(0.15), radius: 2)
                
                Image(systemName: "person.2.fill")
                    .font(.headline)
                    .foregroundColor(modelData.tab == .friends ? Tab.friends.activeForegroundColor : Tab.friends.inactiveForegroundColor)
            }
            .frame(width: 40, height: 40)
            .animation(.easeInOut(duration: 0.2))
            .onTapGesture {
                Impact(style: .light)
                modelData.tab = .friends
            }
        }
    }
    
    var isLoading: Bool {
        switch modelData.checkState {
        case .sleep, .wake:
            return false
        case .loading:
            return true
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        let modelData = ModelData()
        
        TabBarView()
            .environmentObject(modelData)
    }
}
