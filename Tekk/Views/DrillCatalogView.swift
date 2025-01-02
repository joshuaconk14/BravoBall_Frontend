//
//  DrillCatalogView.swift
//  BravoBall
//
//  Created by Jordan on 12/30/24.
//

import SwiftUI
import RiveRuntime

struct DrillCatalogView: View {
    @StateObject var viewModel = DrillCatalogViewModel()
    @StateObject private var globalSettings = GlobalSettings()
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white.edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Bravo Header
                        HStack(alignment: .top, spacing: 15) {
                            // Bravo animation
                            RiveViewModel(fileName: "test_panting").view()
                                .frame(width: 100, height: 100)
                            
                            // Bravo's message
                            Text("Check out all our available drills...")
                                .font(.custom("Poppins-Bold", size: 16))
                                .foregroundColor(globalSettings.primaryDarkColor)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(globalSettings.primaryYellowColor.opacity(0.1))
                                )
                        }
                        .padding(.horizontal)
                        
                        // Drills Grid
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(viewModel.drills) { drill in
                                DrillCatalogCard(drill: drill)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Drill Catalog")
        }
        .task {
            await viewModel.loadDrills()
        }
    }
}



struct DrillCatalogView_Previews: PreviewProvider {
    static var previews: some View {
        let previewViewModel = PreviewDrillCatalogViewModel()
        DrillCatalogView(viewModel: previewViewModel)
            .environmentObject(GlobalSettings())
            .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro"))
    }
}

// Preview helper class
class PreviewDrillCatalogViewModel: DrillCatalogViewModel {
    override init() {
        super.init()
        self.drills = [
            DrillRecommendation(
                id: 1,
                title: "Wall Passing",
                description: "Improve your passing accuracy and first touch",
                category: "Passing",
                duration: 20,
                difficulty: "Beginner",
                recommended_equipment: ["Ball", "Wall"],
                instructions: ["Set up 2 yards from wall", "Pass ball against wall"],
                tips: ["Keep your head up", "Use both feet"],
                video_url: "",
                matchScore: DrillRecommendation.MatchScore(
                    skillLevelMatch: true,
                    equipmentAvailable: true,
                    recommendedForPosition: true,
                    calculatedScore: 1.5
                )
            ),
            DrillRecommendation(
                id: 2,
                title: "Shooting Form",
                description: "Perfect your shooting technique",
                category: "Shooting",
                duration: 15,
                difficulty: "Intermediate",
                recommended_equipment: ["Ball", "Hoop"],
                instructions: ["Start close to basket", "Focus on form"],
                tips: ["Follow through", "Bend knees"],
                video_url: "",
                matchScore: DrillRecommendation.MatchScore(
                    skillLevelMatch: true,
                    equipmentAvailable: true,
                    recommendedForPosition: true,
                    calculatedScore: 1.4
                )
            ),
            DrillRecommendation(
                id: 3,
                title: "Cone Dribbling",
                description: "Improve ball handling and control",
                category: "Ball Handling",
                duration: 25,
                difficulty: "Advanced",
                recommended_equipment: ["Ball", "Cones"],
                instructions: ["Set up cones", "Dribble through pattern"],
                tips: ["Stay low", "Keep head up"],
                video_url: "",
                matchScore: DrillRecommendation.MatchScore(
                    skillLevelMatch: true,
                    equipmentAvailable: true,
                    recommendedForPosition: true,
                    calculatedScore: 1.3
                )
            ),
            DrillRecommendation(
                id: 4,
                title: "Defensive Slides",
                description: "Work on defensive footwork",
                category: "Defense",
                duration: 10,
                difficulty: "Beginner",
                recommended_equipment: ["Cones"],
                instructions: ["Set up lateral course", "Practice slides"],
                tips: ["Stay in stance", "Quick feet"],
                video_url: "",
                matchScore: DrillRecommendation.MatchScore(
                    skillLevelMatch: true,
                    equipmentAvailable: true,
                    recommendedForPosition: true,
                    calculatedScore: 1.2
                )
            )
        ]
    }
}
