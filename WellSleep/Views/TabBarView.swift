//
//  TabBarView.swift
//  WellSleep
//
//  Created by Sketch on 2021/7/5.
//

import SwiftUI

struct TabBarView: View {
    @Binding var checkState: CheckState
    @State var checkOnTapped = false
    var onTapAction: () -> Void = {}
    
    init(checkState: Binding<CheckState>) {
        self._checkState = checkState
    }
    
    init(checkState: Binding<CheckState>, onTapAction action: @escaping () -> Void) {
        self._checkState = checkState
        self.onTapAction = action
    }
    
    var body: some View {
        let checkTap = DragGesture(minimumDistance: 0)
            .onChanged { value in
                checkOnTapped = true
                if checkState != .loading && value.translation == CGSize(width: 0.0, height: 0.0) {
                    Impact(style: .light)
                }
            }
            .onEnded { value in
                checkOnTapped = false
                if checkState != .loading && sqrt(value.translation.width * value.translation.width + value.translation.height * value.translation.height) < 38.4 {
                    Impact(style: .light)
                    onTapAction()
                }
            }
        
        return HStack {
            Spacer()
            
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

            Spacer()
        }
        .frame(height: 64)
        .gesture(checkTap)
        .scaleEffect(checkOnTapped && checkState != .loading ? 1.2 : 1.0)
        .animation(.easeInOut(duration: 0.2))
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView(checkState: .constant(.sleep))
    }
}
