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
        HStack {
            ZStack {
                Circle()
                    .foregroundColor(user.color)
                
                Text(String(user.nickname.first ?? " "))
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .lineLimit(1)
            }
            .frame(width: 55.0, height: 55.0)
            
            Text(user.nickname)
                .font(.custom("Baloo Thambi Regular", size: 28.0))
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
