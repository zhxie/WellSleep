//
//  UsersView.swift
//  WellSleep
//
//  Created by Sketch on 2021/7/12.
//

import SwiftUI

struct UsersView: View {
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        ScrollView (showsIndicators: false) {
            ZStack {
                HStack {
                    Spacer()
                    Text("")
                        .hidden()
                    Spacer()
                }
                
                VStack (spacing: 12) {
                    UserView(user: modelData.me)
                    AddUserView()
                    
                    HStack {
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(Color(UIColor.secondarySystemFill))
                        
                        Text("friends")
                            .font(.custom("Baloo Thambi Regular", size: 16.0))
                            .foregroundColor(Color(UIColor.secondarySystemFill))
                            .lineLimit(1)
                        
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(Color(UIColor.secondarySystemFill))
                    }
                    .padding(.vertical, 4)
                    
                    ForEach (modelData.users, id: \.self.id) { user in
                        UserView(user: user)
                    }
                }
                .padding(.horizontal, 24)
                .animation(.default)
            }
        }
        .onAppear(perform: {
            modelData.updateFriends()
        })
    }
}

struct UsersView_Previews: PreviewProvider {
    static var previews: some View {
        let modelData = ModelData()
        
        return UsersView()
            .environmentObject(modelData)
    }
}
