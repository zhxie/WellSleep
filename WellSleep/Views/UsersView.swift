//
//  UsersView.swift
//  WellSleep
//
//  Created by Sketch on 2021/7/12.
//

import SwiftUI

struct UsersView: View {
    @EnvironmentObject var modelData: ModelData
    @State var showCode = false
    
    var body: some View {
        ZStack {
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
                        ShowUserCodeView()
                            .onTapGesture {
                                if !showCode {
                                    Impact(style: .light)
                                    withAnimation {
                                        showCode = true
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        withAnimation {
                                            showCode = false
                                        }
                                    }
                                }
                            }
                        
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
            
            if showCode {
                CodeView(id: modelData.me.id)
                    .transition(.opacity)
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
