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
        ZStack{
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    Text("")
                        .hidden()
                    Spacer()
                }
                
                Spacer()
            }
            
            VStack {
                if modelData.me == nil {
                    if !modelData.isRegisteringOrLoggingIn {
                        Spacer()
                        
                        VStack (spacing: 0) {
                            Text("wellsleep-prefix")
                                .font(.system(size: 36))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("wellsleep")
                                .font(.system(size: 64))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("wellsleep-suffix")
                                .font(.system(size: 36))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        VStack(spacing: 16.0) {
                            ZStack {
                                Capsule()
                                    .foregroundColor(.white)
                                
                                TextField(isLogin ? "id" : "nickname", text: $nickname)
                                    .font(.largeTitle)
                                    .foregroundColor(.accentColor)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(1)
                                    .keyboardType(isLogin ? .numberPad : .default)
                                    .background(Color.white.opacity(0))
                                    .padding(.horizontal)
                            }
                            .frame(height: 72.0)
                            
                            HStack {
                                GeometryReader { g in
                                    HStack {
                                        Button(action: {
                                            isLogin.toggle()
                                            nickname = ""
                                            UIApplication.shared.endEditing()
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
                    } else {
                        VStack {
                            Spacer()
                            
                            HStack {
                                Spacer()
                                
                                ProgressView()
                                    .scaleEffect(1.5)
                                
                                Spacer()
                            }
                            
                            Spacer()
                        }
                    }
                } else {
                    Spacer()
                    
                    VStack (spacing: 0) {
                        Text("your_id_is")
                            .font(.system(size: 36))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text(String(format: "%09d", modelData.me!.id))
                            .font(.system(size: 48))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        modelData.completeRegistration()
                    }, label: {
                        ZStack {
                            Capsule()
                                .foregroundColor(.accentColor)
                            
                            Text("next")
                                .font(.title2)
                                .fontWeight(.bold)
                                .lineLimit(1)
                                .foregroundColor(.white)
                        }
                    })
                    .frame(height: 54.0)
                    .padding(.horizontal, 24.0)
                    
                    Spacer()
                }
            }
        }
        .background(Color.background)
        .ignoresSafeArea(.container)
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        let modelData = ModelData()
        
        RegisterView()
            .environmentObject(modelData)
    }
}
