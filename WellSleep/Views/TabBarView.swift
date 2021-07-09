//
//  TabBarView.swift
//  WellSleep
//
//  Created by Sketch on 2021/7/5.
//

import SwiftUI

struct TabBarView: View {
    @Binding var checkState: CheckState
    @GestureState var checkOnTapped = false
    var onLongPressGesture: () -> Void = {}
    
    init(checkState: Binding<CheckState>) {
        self._checkState = checkState
    }
    
    init(checkState: Binding<CheckState>, onLongPressGesture action: @escaping () -> Void) {
        self._checkState = checkState
        self.onLongPressGesture = action
    }
    
    var body: some View {
        let checkTap = LongPressGesture(minimumDuration: 2.0, maximumDistance: 38.4)
            .updating($checkOnTapped) { currentstate, gestureState, _ in
                gestureState = currentstate
                Impact(style: .light)
            }
            .onEnded { value in
                Impact(style: .medium)
                onLongPressGesture()
            }
        
        return ZStack {
            ZStack {
                Sector(start: .degrees(-90), end: .degrees(checkOnTapped ? 270 : -90))
                    .foregroundColor(Color(UIColor.secondarySystemBackground).opacity(0.75))
                    .animation(checkOnTapped ? .linear(duration: 2.0) : .linear(duration: 0))
            }
            .scaleEffect(checkOnTapped && checkState != .loading ? 1.8 : 1.0)
            .animation(.easeInOut(duration: 0.2))
            
            ZStack {
                Circle()
                    .foregroundColor(checkState.backgroundColor)
                
                if (checkState == .loading) {
                    ProgressView()
                        .scaleEffect(1.5)
                } else {
                    Image(systemName: checkState.systemName)
                        .font(.system(size: 21))
                        .foregroundColor(checkState.foregroundColor)
                }
            }
            .scaleEffect(checkOnTapped && checkState != .loading ? 1.2 : 1.0)
            .gesture(checkTap)
            .disabled(checkState == .loading)
            .animation(.easeInOut(duration: 0.2))
        }
        .frame(width: 64, height: 64)
        
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView(checkState: .constant(.sleep))
    }
}
