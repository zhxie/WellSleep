//
//  AddUserView.swift
//  WellSleep
//
//  Created by Sketch on 2021/7/12.
//

import SwiftUI

struct AddUserView: View {
    var body: some View {
        HStack {
            ZStack {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 55.0))
                    .foregroundColor(Color(red: 134 / 255, green: 198 / 255, blue: 203 / 255))
            }
            .frame(width: 55.0, height: 55.0)
            
            Text("add_user")
                .font(.custom("Baloo Thambi Regular", size: 28.0))
                .lineLimit(1)
                .layoutPriority(1)
            
            Spacer()
        }
    }
}

struct AddUserView_Previews: PreviewProvider {
    static var previews: some View {
        AddUserView()
    }
}
