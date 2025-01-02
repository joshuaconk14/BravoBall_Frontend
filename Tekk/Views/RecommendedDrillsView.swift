//
//  RecommendedDrillsView.swift
//  BravoBall
//
//  Created by Jordan on 12/30/24.
//

import SwiftUI
import RiveRuntime

// RecommendedDrillsView is the view for displaying recommended drills
struct RecommendedDrillsView: View {
    @StateObject private var globalSettings = GlobalSettings()
    @StateObject private var drillsViewModel = DrillsViewModel.shared
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white.edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 20) {
                        HStack(alignment: .top, spacing: 15) {
                            // Bravo animation
                            RiveViewModel(fileName: "test_panting").view()
                                .frame(width: 100, height: 100)
                            
                            // Bravo's message
                            Text("I think these drills would be best for you...")
                                .font(.custom("Poppins-Bold", size: 18))
                                .foregroundColor(globalSettings.primaryDarkColor)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.gray.opacity(0.1))
                                )
                        }
                        .padding()
                        
                        // Loop through the recommended drills and display them
                        ForEach(drillsViewModel.recommendedDrills) { drill in
                            DrillRecommendationCard(
                                drill: drill,
                                userEquipment: drillsViewModel.userEquipment
                            )
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .navigationTitle("Recommended Drills")
        }
    }
}

// DrillRecommendationCard is the view for displaying a single drill recommendation
struct DrillRecommendationCard: View {
    @StateObject private var globalSettings = GlobalSettings()
    let drill: DrillRecommendation
    let userEquipment: [String]
    @State private var showDetails = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Title and duration
            HStack {
                Text(drill.title)
                    .font(.custom("Poppins-Bold", size: 18))
                    .foregroundColor(globalSettings.primaryDarkColor)
                
                Spacer()
                
                Text("\(drill.duration) mins")
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(.gray)
            }
            
            // Description
            Text(drill.description)
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(.gray)
            
            // Match score indicators
            HStack(spacing: 8) {
                if drill.matchScore.skillLevelMatch {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
                
                Text("Difficulty: \(drill.difficulty)")
                    .font(.custom("Poppins-Regular", size: 12))
                    .foregroundColor(.gray)
                                
                Spacer()
                
                Text(drill.category)
                    .font(.custom("Poppins-Bold", size: 12))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
            
            // Equipment tags
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(drill.recommended_equipment, id: \.self) { item in
                        HStack(spacing: 4) {
                            // Check if the user has the equipment
                            let hasEquipment = userEquipment.contains(item)
                        
                            Image(systemName: hasEquipment ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(hasEquipment ? .green : .red)
                            
                            Text(item)
                        }
                        .font(.custom("Poppins-Regular", size: 12))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(globalSettings.primaryYellowColor.opacity(0.2))
                        .cornerRadius(8)
                    }
                }
            }
            
            // Expandable details section
            if showDetails {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Instructions:")
                        .font(.custom("Poppins-Bold", size: 14))
                    ForEach(drill.instructions, id: \.self) { instruction in
                        Text("• \(instruction)")
                            .font(.custom("Poppins-Regular", size: 12))
                    }
                    
                    Text("Tips:")
                        .font(.custom("Poppins-Bold", size: 14))
                        .padding(.top, 4)
                    ForEach(drill.tips, id: \.self) { tip in
                        Text("• \(tip)")
                            .font(.custom("Poppins-Regular", size: 12))
                    }
                }
                .padding(.vertical, 8)
            }
            
            // Show details toggle
            Button(action: { showDetails.toggle() }) {
                Text(showDetails ? "Show Less" : "Show More")
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(globalSettings.primaryYellowColor)
            }
            
            // Start drill button
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

// MARK: - Preview
struct RecommendedDrillsView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = DrillsViewModel.shared
        
        // Set up sample data
        viewModel.recommendedDrills = [
            DrillRecommendation(
                id: 1,
                title: "Wall Passing",
                description: "Improve your passing accuracy and first touch with this wall passing drill. Focus on using both feet and maintaining proper technique.",
                category: "Passing",
                duration: 20,
                difficulty: "Medium",
                recommended_equipment: ["Ball", "Wall"],
                instructions: [
                    "Set up 2 yards from wall",
                    "Pass ball against wall",
                    "Control the rebound",
                    "Repeat with both feet"
                ],
                tips: [
                    "Keep your head up",
                    "Use both feet",
                    "Stay on your toes"
                ],
                video_url: "https://youtube.com/example1",
                matchScore: DrillRecommendation.MatchScore(
                    skillLevelMatch: true,
                    equipmentAvailable: true,
                    recommendedForPosition: true,
                    calculatedScore: 1.5
                )
            ),
            DrillRecommendation(
                id: 2,
                title: "Cone Weaves",
                description: "Enhance your dribbling control and agility by weaving through cones. Practice with both feet and gradually increase your speed.",
                category: "Dribbling",
                duration: 15,
                difficulty: "Medium",
                recommended_equipment: ["Ball", "Cones"],
                instructions: [
                    "Set up 6 cones in line",
                    "Dribble through cones",
                    "Return to start",
                    "Repeat with other foot"
                ],
                tips: [
                    "Keep ball close",
                    "Look up occasionally",
                    "Use both feet"
                ],
                video_url: "https://youtube.com/example2",
                matchScore: DrillRecommendation.MatchScore(
                    skillLevelMatch: true,
                    equipmentAvailable: true,
                    recommendedForPosition: true,
                    calculatedScore: 1.3
                )
            )
        ]
        
        return RecommendedDrillsView()
    }
}
