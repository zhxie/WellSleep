//
//  UserView.swift
//  WellSleep
//
//  Created by Sketch on 2021/7/12.
//

import SwiftUI

struct UserView: View {
    var user: User
    
    var body: some View {
        HStack (spacing: 12) {
            ZStack {
                Circle()
                    .foregroundColor(user.color)
                
                Text(String(user.nickname.first?.uppercased() ?? " "))
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .lineLimit(1)
            }
            .frame(width: 55.0, height: 55.0)
            
            Text(user.nickname)
                .font(.title)
                .fontWeight(.bold)
                .lineLimit(1)
                .layoutPriority(1)
            
            Spacer()
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(user: UserPlaceholder)
    }
}
