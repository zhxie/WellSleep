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
                        UserView(user: modelData.me)
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
                        
                        ForEach (modelData.users, id: \.self.id) { user in
                            UserView(user: user)
                        }
                    }
                    .padding(.horizontal, 24)
                    .animation(.default)
                }
            }
            
            if isShowingCode {
                CodeView(id: modelData.me.id)
                    .transition(.opacity)
            }
        }
        .sheet(isPresented: $isShowingScanner) {
            CodeScannerView(codeTypes: [.qr], completion: handleScan)
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
        
        return UsersView()
            .environmentObject(modelData)
    }
}
