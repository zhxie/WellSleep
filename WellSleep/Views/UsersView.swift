//
//  UsersView.swift
//  WellSleep
//
//  Created by Sketch on 2021/7/12.
//

import SwiftUI
import CodeScanner

struct UsersView: View {
    @EnvironmentObject var modelData: ModelData
    @State var isShowingScanner = false
    @State var isShowingCode = false
    @Binding var user: User?
    
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
                    
                    LazyVStack (spacing: 12) {
                        if modelData.isMeUpdating {
                            HStack {
                                Spacer()
                                
                                ProgressView()
                                    .scaleEffect(1.5)
                                
                                Spacer()
                            }
                        }
                        
                        UserView(user: modelData.me!)
                        AddUserView()
                            .onTapGesture {
                                if !isShowingScanner {
                                    Impact(style: .light)
                                    isShowingScanner = true
                                }
                            }
                        ShowCodeView()
                            .onTapGesture {
                                if !isShowingCode {
                                    Impact(style: .light)
                                    withAnimation {
                                        isShowingCode = true
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        withAnimation {
                                            isShowingCode = false
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
                        
                        if modelData.isUsersUpdating {
                            HStack {
                                Spacer()
                                
                                ProgressView()
                                    .scaleEffect(1.5)
                                
                                Spacer()
                            }
                        }
                        
                        ForEach (modelData.users, id: \.self.id) { user in
                            UserView(user: user)
                                .onTapGesture {
                                    Impact(style: .light)
                                    self.user = user
                                }
                        }
                    }
                    .padding(.horizontal, 24)
                    .animation(.default)
                }
            }
            
            if isShowingCode {
                CodeView(id: modelData.me!.id)
                    .transition(.opacity)
            }
        }
        .sheet(isPresented: $isShowingScanner) {
            ZStack {
                CodeScannerView(codeTypes: [.qr], completion: handleScan)
                
                VStack {
                    Spacer()
                    
                    Spacer()
                    
                    Spacer()
                    
                    Spacer()
                    
                    Text("please_scan_your_friend_s_qr_code")
                        .fontWeight(.medium)
                        .foregroundColor(.white.opacity(0.67))
                        .padding(.horizontal)
                    
                    Spacer()
                }
            }
            .ignoresSafeArea(.container)
        }
        .onAppear {
            modelData.updateFriends()
        }
    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        isShowingScanner = false
        
        switch result {
        case .success(let result):
            if let id = Int(result) {
                modelData.addFriend(id: id)
            }
        case .failure(_):
            return
        }
    }
}

struct UsersView_Previews: PreviewProvider {
    static var previews: some View {
        let modelData = ModelData()
        
        return UsersView(user: .constant(nil))
            .environmentObject(modelData)
    }
}
