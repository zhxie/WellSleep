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
                Circle()
                    .foregroundColor(.background)
                
                Image(systemName: "plus")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(1)
            }
            .frame(width: 55.0, height: 55.0)
            
            Text("add_a_friend")
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
