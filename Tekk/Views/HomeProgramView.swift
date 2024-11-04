//
//  HomeHomeProgramView.swift
//  BravoBall
//
//  Created by Jordan on 11/3/24.
//
// This file contains the view for the home program screen.

import Foundation
import SwiftUI
import RiveRuntime

struct HomeProgramView: View {
    @StateObject private var globalSettings = GlobalSettings()
    @State private var selectedWeek: Int = 1
    @State private var showWeekSelector = false
    
    // Sample data structures
    struct WeekCard: Identifiable {
        let id = UUID()
        let weekNumber: Int
        let title: String
        let description: String
        let drills: [DrillCard]
        let isLocked: Bool
    }
    
    struct DrillCard: Identifiable {
        let id = UUID()
        let title: String
        let description: String
        let duration: String
        let isCompleted: Bool
    }
    
    // Sample data
    let weeks = [
        WeekCard(
            weekNumber: 1,
            title: "Foundation Week",
            description: "Master the basics",
            drills: [
                DrillCard(title: "Basic Dribbling",
                         description: "Master the basics of ball control",
                         duration: "15 mins",
                         isCompleted: false),
                DrillCard(title: "Passing Practice",
                         description: "Short passing drills",
                         duration: "20 mins",
                         isCompleted: false),
                DrillCard(title: "First Touch",
                         description: "Improve your ball reception",
                         duration: "15 mins",
                         isCompleted: false),
                DrillCard(title: "Shooting Basics",
                         description: "Learn proper shooting technique",
                         duration: "25 mins",
                         isCompleted: false)
            ],
            isLocked: false
        ),
        WeekCard(
            weekNumber: 2,
            title: "Technical Focus",
            description: "Advance your skills",
            drills: [
                DrillCard(title: "Advanced Dribbling",
                         description: "Complex ball control exercises",
                         duration: "20 mins",
                         isCompleted: false),
                DrillCard(title: "Long Passing",
                         description: "Distance passing accuracy",
                         duration: "25 mins",
                         isCompleted: false),
                DrillCard(title: "Ball Mastery",
                         description: "Advanced ball control drills",
                         duration: "20 mins",
                         isCompleted: false)
            ],
            isLocked: true
        ),
        WeekCard(
            weekNumber: 3,
            title: "Speed & Agility",
            description: "Quick movements with the ball",
            drills: [
                DrillCard(title: "Speed Dribbling",
                         description: "High-tempo ball control",
                         duration: "20 mins",
                         isCompleted: false),
                DrillCard(title: "Agility Course",
                         description: "Quick direction changes",
                         duration: "25 mins",
                         isCompleted: false),
                DrillCard(title: "Sprint Training",
                         description: "Explosive movements",
                         duration: "15 mins",
                         isCompleted: false)
            ],
            isLocked: true
        )
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Header with week selector
                    Button(action: { showWeekSelector.toggle() }) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Week \(selectedWeek)")
                                    .font(.custom("Poppins-Bold", size: 24))
                                    .foregroundColor(globalSettings.primaryDarkColor)
                                
                                Text(weeks[selectedWeek - 1].description)
                                    .font(.custom("Poppins-Regular", size: 14))
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.down")
                                .foregroundColor(globalSettings.primaryDarkColor)
                        }
                        .padding()
                        .background(Color.white)
                    }
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            // Bravo avatar now inside ScrollView
                            RiveViewModel(fileName: "test_panting").view()
                                .frame(width: 150, height: 150)
                            
                            // Drills
                            ForEach(weeks[selectedWeek - 1].drills) { drill in
                                DrillCardView(drill: drill)
                            }
                        }
                        .padding()
                    }
                }
                
                // Week selector overlay
                if showWeekSelector {
                    Color.black.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                showWeekSelector = false
                            }
                        }
                    
                    VStack {
                        Spacer()
                        
                        VStack(spacing: 0) {
                            ForEach(weeks) { week in
                                Button(action: {
                                    withAnimation {
                                        if !week.isLocked {
                                            selectedWeek = week.weekNumber
                                            showWeekSelector = false
                                        }
                                    }
                                }) {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text("Week \(week.weekNumber)")
                                                .font(.custom("Poppins-Bold", size: 16))
                                            Text(week.description)
                                                .font(.custom("Poppins-Regular", size: 14))
                                        }
                                        .foregroundColor(week.isLocked ? .gray : globalSettings.primaryDarkColor)
                                        
                                        Spacer()
                                        
                                        if week.isLocked {
                                            Image(systemName: "lock.fill")
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    .padding()
                                    .background(Color.white)
                                }
                                
                                if week.weekNumber != weeks.count {
                                    Divider()
                                }
                            }
                        }
                        .background(Color.white)
                        .cornerRadius(15)
                        .padding()
                    }
                    .transition(.move(edge: .bottom))
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct DrillCardView: View {
    @StateObject private var globalSettings = GlobalSettings()
    let drill: HomeProgramView.DrillCard
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(drill.title)
                    .font(.custom("Poppins-Bold", size: 18))
                    .foregroundColor(globalSettings.primaryDarkColor)
                
                Spacer()
                
                Text(drill.duration)
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(.gray)
            }
            
            Text(drill.description)
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(.gray)
            
            Button(action: {}) {
                Text("Start Drill")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(globalSettings.primaryYellowColor)
                    .cornerRadius(20)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
    }
}


struct HomeProgramView_Previews: PreviewProvider {
    static var previews: some View {
        HomeProgramView()
    }
}