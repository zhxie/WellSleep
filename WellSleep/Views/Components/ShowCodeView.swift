//
//  ShowCodeView.swift
//  WellSleep
//
//  Created by Sketch on 2021/7/12.
//

import SwiftUI

struct ShowCodeView: View {
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .foregroundColor(Color(red: 245 / 255, green: 229 / 255, blue: 151 / 255))
                
                Image(systemName: "qrcode")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(1)
            }
            .frame(width: 55.0, height: 55.0)
            
            Text("show_qr_code")
                .font(.custom("Baloo Thambi Regular", size: 28.0))
                .lineLimit(1)
                .layoutPriority(1)
            
            Spacer()
        }
    }
}

struct ShowUserCodeView_Previews: PreviewProvider {
    static var previews: some View {
        ShowCodeView()
    }
}
