//
//  ActivitiesView.swift
//  WellSleep
//
//  Created by Sketch on 2021/7/21.
//

import SwiftUI

struct ActivitiesView: View {
    @State var user: User
    @State var activities: [Activity] = []
    @State var oldestActivityId = 0
    
    @State var isUserUpdating = false
    @State var isActivitiesUpdating = false
    @State var activitiesUpdatingSide: TimelineUpdatingSide = .top
    
    var body: some View {
        ScrollView (showsIndicators: false) {
            ZStack {
                HStack {
                    Spacer()
                    Text("")
                        .hidden()
                    Spacer()
                }
                
                LazyVStack (spacing: 12) {
                    Spacer()
                        .frame(height: 12)
                    
                    if isUserUpdating {
                        HStack {
                            Spacer()
                            
                            ProgressView()
                                .scaleEffect(1.5)
                            
                            Spacer()
                        }
                    }
                    
                    UserView(user: user)
                    
                    HStack {
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(Color(UIColor.secondarySystemFill))
                        
                        Text("activities")
                            .font(.custom("Baloo Thambi Regular", size: 16.0))
                            .foregroundColor(Color(UIColor.secondarySystemFill))
                            .lineLimit(1)
                        
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(Color(UIColor.secondarySystemFill))
                    }
                    .padding(.vertical, 4)
                    
                    if isActivitiesUpdating && activitiesUpdatingSide == .top {
                        HStack {
                            Spacer()
                            
                            ProgressView()
                                .scaleEffect(1.5)
                            
                            Spacer()
                        }
                    }
                    
                    ForEach (activities, id: \.self.id) { activity in
                        ActivityView(activity: activity)
                            .onAppear {
                                guard activity.id == oldestActivityId else {
                                    return
                                }
                                
                                append()
                            }
                    }
                    
                    if isActivitiesUpdating && activitiesUpdatingSide == .bottom {
                        HStack {
                            Spacer()
                            
                            ProgressView()
                                .scaleEffect(1.5)
                            
                            Spacer()
                        }
                    }
                
                    Spacer()
                        .frame(height: 12)
                }
            }
        }
        .onAppear {
            update()
        }
    }

    func update() {
        if isUserUpdating || isActivitiesUpdating {
            return
        } else {
            withAnimation {
                isUserUpdating = true
                activitiesUpdatingSide = .top
                isActivitiesUpdating = true
            }
            
            getUser(id: user.id) { user, error in
                guard let user = user else {
                    DispatchQueue.main.async {
                        withAnimation {
                            self.isUserUpdating = false
                            self.isActivitiesUpdating = false
                        }
                    }
                    
                    return
                }
                
                getActivities(user: user, to: 0, limit: Limit) { activities, error in
                    guard let activities = activities else {
                        DispatchQueue.main.async {
                            withAnimation {
                                self.isUserUpdating = false
                                self.isActivitiesUpdating = false
                            }
                        }
                        
                        return
                    }
                    
                    DispatchQueue.main.async {
                        withAnimation {
                            self.user = user
                            self.activities = activities
                            self.oldestActivityId = activities.last?.id ?? 0
                            
                            self.isUserUpdating = false
                            self.isActivitiesUpdating = false
                        }
                    }
                }
            }
        }
    }
    
    func append() {
        if isActivitiesUpdating {
            return
        } else {
            withAnimation {
                activitiesUpdatingSide = .bottom
                isActivitiesUpdating = true
            }
        
            getActivities(user: user, to: oldestActivityId, limit: Limit) { activities, error in
                guard let activities = activities else {
                    DispatchQueue.main.async {
                        self.isActivitiesUpdating = false
                    }
                    
                    return
                }
                
                DispatchQueue.main.async {
                    self.activities.append(contentsOf: activities)
                    self.oldestActivityId = activities.last?.id ?? 0
                    
                    self.isActivitiesUpdating = false
                }
            }
        }
    }
}

struct ActivitiesView_Previews: PreviewProvider {
    static var previews: some View {
        ActivitiesView(user: UserPlaceholder)
    }
}
