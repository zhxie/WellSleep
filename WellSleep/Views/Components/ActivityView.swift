//
//  ActivityView.swift
//  WellSleep
//
//  Created by Sketch on 2021/6/21.
//

import SwiftUI

struct ActivityView: View {
    @EnvironmentObject var modelData: ModelData
    
    var activity: Activity
    var onTap: () -> Void = {}
    
    var body: some View {
        return HStack {
            ZStack {
                Circle()
                    .foregroundColor(activity.user.color)
                
                Text(String(activity.user.nickname.first?.uppercased() ?? " "))
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                if modelData.lastUpdate < activity.time {
                    VStack {
                        HStack {
                            Spacer()
                            
                            Circle()
                                .foregroundColor(Color(red: 239 / 255, green: 139 / 255, blue: 119 / 255))
                                .frame(width: 15, height: 15)
                        }
                        
                        Spacer()
                    }
                }
            }
            .frame(width: 55.0, height: 55.0)
            .animation(.easeInOut)
            .onTapGesture {
                onTap()
            }
            
            HStack (spacing: 0) {
                Path { path in
                    path.move(to: CGPoint(x: 0.0, y: 5.5))
                    path.addLine(to: CGPoint(x: 12.0, y: 0))
                    path.addLine(to: CGPoint(x: 12.0, y: 11.0))
                }
                .frame(width: 12, height: 11)
                
                HStack (alignment: .center) {
                    GeometryReader { g in
                        ZStack (alignment: .leading) {
                            Rectangle()
                            
                            if let image = activity.image {
                                HStack {
                                    Spacer()
                                    
                                    Image(image)
                                        .resizable()
                                        .scaledToFit()
                                }
                            }
                            
                            HStack (alignment: .center) {
                                Spacer()
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                Spacer()
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                
                                VStack (alignment: .center, spacing: -8) {
                                    Text(activity.time.formatDate())
                                        .font(.custom("Baloo Thambi Regular", size: 12.0))
                                        .foregroundColor(activity.type.foregroundColor)
                                        .lineLimit(1)
                                    Text(activity.time.formatWeekday())
                                        .font(.custom("Baloo Thambi Regular", size: 12.0))
                                        .foregroundColor(activity.type.foregroundColor)
                                        .lineLimit(1)
                                }
                                .layoutPriority(1)
                                
                                Spacer()
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                
                                Text(activity.time.formatTime())
                                    .font(.custom("Baloo Thambi Regular", size: 28.0))
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                                    .layoutPriority(1)
                                
                                Spacer()
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                Spacer()
                                    .frame(minWidth: 0, maxWidth: .infinity)
                            }
                            .frame(width: g.size.width * 0.6, height: g.size.height)
                        }
                        .cornerRadius(15.0)
                    }
                }
                .frame(height: 55.0)
            }
            .foregroundColor(activity.backgroundColor)
        }
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        let modelData = ModelData()
        
        return ActivityView(activity: ActivityPlaceholder)
            .environmentObject(modelData)
    }
}
