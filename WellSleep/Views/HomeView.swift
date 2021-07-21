//
//  HomeView.swift
//  WellSleep
//
//  Created by Sketch on 2021/7/2.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var modelData: ModelData
    
    @Binding var user: User?
    
    var body: some View {
        ScrollView (showsIndicators: false) {
            ZStack {
                HStack {
                    Spacer()
                    Text("")
                        .hidden()
                    Spacer()
                }
                
                LazyVStack (alignment: .leading, spacing: 12) {
                    if modelData.isTimelineUpdating && modelData.timelineUpdatingSide == .top {
                        HStack {
                            Spacer()
                            
                            ProgressView()
                                .scaleEffect(1.5)
                            
                            Spacer()
                        }
                    }
                    
                    ForEach (groupedActivities, id: \.self.first!.id) { activitiesGroup in
                        if activitiesGroup.first!.time.formatFullDate() != Date().formatFullDate() {
                            HStack {
                                Rectangle()
                                    .frame(height: 2)
                                    .foregroundColor(Color(UIColor.secondarySystemFill))
                                
                                Text(String(format: "%@ %@", activitiesGroup.first!.time.formatDate(), activitiesGroup.first!.time.formatWeekday()))
                                    .font(.custom("Baloo Thambi Regular", size: 16.0))
                                    .foregroundColor(Color(UIColor.secondarySystemFill))
                                    .lineLimit(1)
                                
                                Rectangle()
                                    .frame(height: 2)
                                    .foregroundColor(Color(UIColor.secondarySystemFill))
                            }
                            .padding(.vertical, 4)
                        }
                        
                        ForEach (activitiesGroup, id: \.self.id) { activity in
                            ActivityView(activity: activity, onTap: {
                                Impact(style: .light)
                                user = activity.user
                            })
                                .onAppear {
                                    guard activity.id == modelData.oldestActivityId else {
                                        return
                                    }
                                    
                                    modelData.appendTimeline()
                                }
                        }
                    }
                    
                    if modelData.isTimelineUpdating && modelData.timelineUpdatingSide == .bottom {
                        HStack {
                            Spacer()
                            
                            ProgressView()
                                .scaleEffect(1.5)
                            
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal, 24)
                .animation(.default)
            }
        }
        .onAppear {
            modelData.updateMe()
            modelData.updateTimeline()
        }
    }
    
    var groupedActivities: [[Activity]] {
        var activitiesGroup: [[Activity]] = []
        var activities: [Activity] = []
        var date = "0/0"
        
        for activity in modelData.timeline.sorted(by: { x, y in
            x.time > y.time
        }) {
            let currentDate = activity.time.formatDate()
            if currentDate != date {
                if activities.count > 0 {
                    activitiesGroup.append(activities)
                    activities = []
                }
                date = currentDate
            }
            
            activities.append(activity)
        }
        
        if activities.count > 0 {
            activitiesGroup.append(activities)
        }
        
        return activitiesGroup
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let modelData = ModelData()
        
        return HomeView(user: .constant(nil))
            .environmentObject(modelData)
    }
}
