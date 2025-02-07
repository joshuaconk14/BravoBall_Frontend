//
//  DrillDetailView.swift
//  BravoBall
//
//  Created by Jordan on 1/12/25.
//


import SwiftUI

struct DrillDetailView: View {
    
    @ObservedObject var appModel: MainAppModel
    @ObservedObject var sessionModel: SessionGeneratorModel
    let drill: DrillModel
    
    @Environment(\.dismiss) private var dismiss
    @State private var showingFollowAlong = false
    @State private var showSaveDrill: Bool = false
    
    // MARK: Main view
    var body: some View {
            ZStack {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 24) {
                        HStack(spacing: 25) {
                            Button(action: {
                                
                            }) {
                                Image(systemName: "xmark")
                                    .foregroundColor(.black)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                sessionModel.toggleDrillLike(drillId: drill.id, drill: drill)
                            }) {
                                Image(systemName: sessionModel.isDrillLiked(drill) ? "heart.fill" : "heart")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(sessionModel.isDrillLiked(drill) ? .red : .clear)  // Fill color
                                    .frame(width: 30, height: 30)
                                    .overlay(
                                        Image(systemName: sessionModel.isDrillLiked(drill) ? "heart.fill" : "heart")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundColor(sessionModel.isDrillLiked(drill) ? .red : .black)  // Stroke color
                                            .frame(width: 30, height: 30)
                                    )
                            }
                            
                            Button(action: {
                                showSaveDrill = true
                            }) {
                                Image(systemName: "square.and.arrow.down")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.black)
                                    .frame(width: 30, height: 30)
                            }
                        }
                        .padding()
                        
                        // Video preview
                        ZStack {
                            Rectangle()
                                .fill(Color.black.opacity(0.1))
                                .aspectRatio(16/9, contentMode: .fit)
                                .cornerRadius(12)
                            
                            Button(action: { /* Play video preview */ }) {
                                Image(systemName: "play.circle.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.white)
                                    .background(Circle().fill(Color.black.opacity(0.5)))
                            }
                        }
                        
                        // Drill information
                        VStack(alignment: .leading, spacing: 16) {
                            Text(drill.title)
                                .font(.custom("Poppins-Bold", size: 24))
                            
                            HStack(spacing: 16) {
                                Label(drill.sets + " sets", systemImage: "repeat")
                                Label(drill.reps + " reps", systemImage: "figure.run")
                                Label(drill.duration, systemImage: "clock")
                            }
                            .font(.custom("Poppins-Medium", size: 14))
                            .foregroundColor(.gray)
                        }
                        
                        // Description
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.custom("Poppins-Bold", size: 18))
                            Text(drill.description)
                                .font(.custom("Poppins-Regular", size: 16))
                                .foregroundColor(.gray)
                        }
                        
                        // Tips
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Tips")
                                .font(.custom("Poppins-Bold", size: 18))
                            ForEach(drill.tips, id: \.self) { tip in
                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                    Text(tip)
                                        .font(.custom("Poppins-Regular", size: 16))
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        
                        // Equipment needed
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Equipment Needed")
                                .font(.custom("Poppins-Bold", size: 18))
                            ForEach(drill.equipment, id: \.self) { item in
                                HStack(spacing: 8) {
                                    Image(systemName: "circle.fill")
                                        .font(.system(size: 6))
                                        .foregroundColor(.gray)
                                    Text(item)
                                        .font(.custom("Poppins-Regular", size: 16))
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                    .padding()
                }
                .safeAreaInset(edge: .bottom) {
                    if !appModel.viewState.showHomePage {
                        Button(action: {
                            showingFollowAlong = true
                        }) {
                            Text("Start Drill")
                                .font(.custom("Poppins-Bold", size: 18))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.yellow)
                                .cornerRadius(12)
                        }
                        .padding()
                    }
                    
                }
                
                if showSaveDrill {
                    findGroupToSaveToView
                }
                
            }
            .fullScreenCover(isPresented: $showingFollowAlong) {
                DrillFollowAlongView(drill: drill)
        }
    }
    
    // MARK: Find groups to save view
    
    // TODO: make this a structure?
    private var findGroupToSaveToView: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    showSaveDrill = false
                }
            
            VStack {
                HStack {
                    Button(action: {
                        withAnimation {
                            showSaveDrill = false
                        }
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(appModel.globalSettings.primaryDarkColor)
                            .font(.system(size: 16, weight: .medium))
                    }
                    
                    Spacer()
                    
                    Text("Save to group")
                        .font(.custom("Poppins-Bold", size: 12))
                        .foregroundColor(appModel.globalSettings.primaryGrayColor)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                
                if sessionModel.savedDrills.isEmpty {
                    Text("No groups created yet")
                        .font(.custom("Poppins-Medium", size: 12))
                        .foregroundColor(.gray)
                        .padding()
                    
                } else {
                    // Groups Display
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            ForEach(sessionModel.savedDrills) { group in
                                GroupCard(group: group)
                                        .onTapGesture {
                                            sessionModel.addDrillToGroup(drill: drill, groupId: group.id)
                                        }
                            }
                        }
                        .padding()
                    }
                }
                
                Spacer()
            }
            .padding()
            .frame(width: 300, height: 470)
            .background(Color.white)
            .cornerRadius(15)
        }

    }
            
}

struct InfoItem: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text(value)
                .font(.headline)
        }
        .frame(maxWidth: .infinity)
        .padding()
//        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}


#Preview {
    let mockAppModel = MainAppModel()
    let mockSessionModel = SessionGeneratorModel(onboardingData: OnboardingModel.OnboardingData())

    
    let mockDrill = DrillModel(
        title: "Shooting Drill",
        skill: "Shooting",
        sets: "4",
        reps: "2",
        duration: "20min",
        description: "This drill focuses on improving your shooting accuracy and power. Start by setting up cones in a zigzag pattern, dribble through them, and finish with a shot on goal.",
        tips: [
            "Keep your head down and eyes on the ball when shooting",
            "Follow through with your kicking foot",
            "Plant your non-kicking foot beside the ball",
            "Strike the ball with your laces for power"
        ],
        equipment: [
            "Soccer ball",
            "Cones",
            "Goal"
        ],
        trainingStyle: "Medium Intensity",
        difficulty: "Beginner"
    )
    
    // Create a mock group with the drill
    let mockGroup = GroupModel(
        name: "My First Group",
        description: "Collection of passing drills",
        drills: [mockDrill]
    )
    
    // Add the mock group to savedDrills
    mockSessionModel.savedDrills = [mockGroup]
    
    
    return DrillDetailView(appModel: mockAppModel, sessionModel: mockSessionModel, drill: mockDrill)
}
