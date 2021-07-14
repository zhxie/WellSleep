//
//  RegisterView.swift
//  WellSleep
//
//  Created by Sketch on 2021/7/14.
//

import SwiftUI
import Combine

struct RegisterView: View {
    @EnvironmentObject var modelData: ModelData
    
    @State var nickname = ""
    @State var isLogin = false
    
    var body: some View {
        VStack {
            Spacer()
            
            Spacer()
            
            Text("wellsleep")
                .font(.system(size: 64))
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Spacer()
            
            VStack(spacing: 16.0) {
                ZStack {
                    Capsule()
                        .foregroundColor(.white)
                    
                    TextField("", text: $nickname)
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                        .keyboardType(isLogin ? .numberPad : .default)
                        .background(Color.white)
                        .padding(.horizontal)
                }
                .frame(height: 72.0)
                
                HStack {
                    GeometryReader { g in
                        HStack {
                            Button(action: {
                                isLogin.toggle()
                                nickname = ""
                            }, label: {
                                Text(isLogin ? "register" : "login")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                                    .padding(.leading, 6.0)
                            })
                            
                            Spacer()
                            
                            Button(action: {
                                if isLogin {
                                    guard let id = Int(nickname) else {
                                        return
                                    }
                                    
                                    modelData.login(id: id)
                                } else {
                                    modelData.register(nickname: nickname)
                                }
                            }, label: {
                                ZStack {
                                    Capsule()
                                        .foregroundColor(.accentColor)
                                    
                                    Text(isLogin ? "login" : "register")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .lineLimit(1)
                                        .foregroundColor(.white)
                                }
                            })
                            .frame(width: g.size.width * 0.67)
                        }
                    }
                }
                .frame(height: 54.0)
            }
            .padding(.horizontal, 24.0)
        
            Spacer()
        }
        .background(Color.background)
        .ignoresSafeArea()
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        let modelData = ModelData()
        
        RegisterView()
            .environmentObject(modelData)
    }
}