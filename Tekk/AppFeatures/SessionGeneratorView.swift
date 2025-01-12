//
//  SessionGeneratorView.swift
//  BravoBall
//
//  Created by Jordan on 1/7/25.
//

import Foundation
import SwiftUI

struct SessionGeneratorView: View {
    @ObservedObject var model: OnboardingModel
    @State private var selectedSkills: Set<String> = []
    @State private var sessionDuration: Int = 60 // in minutes
    @State private var selectedEquipment: Set<String> = []
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Skills Section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Skills for Today")
                                .font(.custom("Poppins-Bold", size: 20))
                            Spacer()
                            Button(action: {
                                // Add skill action
                            }) {
                                Image(systemName: "plus")
                                    .foregroundColor(model.globalSettings.primaryYellowColor)
                            }
                        }
                        
                        // Skills Grid
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                            ForEach(model.skills, id: \.self) { skill in
                                SkillButton(
                                    title: skill,
                                    isSelected: selectedSkills.contains(skill),
                                    action: {
                                        if selectedSkills.contains(skill) {
                                            selectedSkills.remove(skill)
                                        } else {
                                            selectedSkills.insert(skill)
                                        }
                                    }
                                )
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    
                    // Equipment Filter
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Equipment")
                                .font(.custom("Poppins-Bold", size: 20))
                            Spacer()
                            Button(action: {
                                // Filter equipment action
                            }) {
                                Image(systemName: "slider.horizontal.3")
                                    .foregroundColor(model.globalSettings.primaryYellowColor)
                            }
                        }
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(model.equipment, id: \.self) { item in
                                    EquipmentButton(
                                        title: item,
                                        isSelected: selectedEquipment.contains(item),
                                        action: {
                                            if selectedEquipment.contains(item) {
                                                selectedEquipment.remove(item)
                                            } else {
                                                selectedEquipment.insert(item)
                                            }
                                        }
                                    )
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    
                    // Generated Drills
                    if !selectedSkills.isEmpty {
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image("BravoBallDog") // Your mascot
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                
                                Text("Looks like you got \(selectedSkills.count) drills for today!")
                                    .font(.custom("Poppins-Bold", size: 16))
                                
                                Spacer()
                            }
                            
                            ForEach(generateDrills(), id: \.name) { drill in
                                DrillCard(drill: drill)
                            }
                            
                            // Start Session Button
                            Button(action: {
                                // Start session action
                            }) {
                                Text("Start Session")
                                    .font(.custom("Poppins-Bold", size: 18))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(model.globalSettings.primaryYellowColor)
                                    .cornerRadius(25)
                            }
                            .padding(.top)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                    }
                }
                .padding()
            }
            .background(Color.gray.opacity(0.1))
            .navigationTitle("Today's Training")
        }
    }
    
    // Sample drill generation
    func generateDrills() -> [Drill] {
        return selectedSkills.map { skill in
            Drill(
                name: "\(skill) Drill",
                duration: "20min",
                sets: "4 sets",
                reps: "2 rep"
            )
        }
    }
}

// Helper Views
struct SkillButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: title.lowercased().contains("dribbling") ? "figure.walk" : "soccerball")
                Text(title)
                    .font(.custom("Poppins-Regular", size: 14))
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(isSelected ? Color.yellow : Color.gray.opacity(0.3), lineWidth: 2)
            )
        }
        .foregroundColor(isSelected ? .yellow : .gray)
    }
}

struct EquipmentButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.custom("Poppins-Regular", size: 14))
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isSelected ? Color.yellow : Color.gray.opacity(0.3), lineWidth: 2)
                )
        }
        .foregroundColor(isSelected ? .yellow : .gray)
    }
}

struct DrillCard: View {
    let drill: Drill
    
    var body: some View {
        HStack {
            // Drill image or icon
            Image(systemName: "figure.soccer")
                .resizable()
                .frame(width: 40, height: 40)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            
            VStack(alignment: .leading) {
                Text(drill.name)
                    .font(.custom("Poppins-Bold", size: 16))
                Text("\(drill.sets) - \(drill.reps) - \(drill.duration)")
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // More options button
            Button(action: {}) {
                Image(systemName: "ellipsis")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
    }
}

// Models
struct Drill {
    let name: String
    let duration: String
    let sets: String
    let reps: String
}

#Preview {
    let mockOnboardingModel = OnboardingModel()
    
    return NavigationView {
        SessionGeneratorView(model: mockOnboardingModel)
            .preferredColorScheme(.light)
    }
}

//// Alternative preview showing different states
//struct SessionGeneratorView_Previews: PreviewProvider {
//    static var previews: some View {
//        let mockModel = OnboardingModel()
//        
//        return Group {
//            // Empty state
//            NavigationView {
//                SessionGeneratorView(model: mockModel)
//            }
//            .previewDisplayName("Empty State")
//            
//            // With selected skills
//            NavigationView {
//                let modelWithSkills = OnboardingModel()
//                SessionGeneratorView(model: modelWithSkills)
//                    .onAppear {
//                        // Pre-select some skills for preview
//                        let view = SessionGeneratorView(model: modelWithSkills)
//                        view.selectedSkills = ["Dribbling", "Passing"]
//                        view.selectedEquipment = ["Ball", "Cones"]
//                    }
//            }
//            .previewDisplayName("With Selections")
//            
//            // Dark mode
//            NavigationView {
//                SessionGeneratorView(model: mockModel)
//            }
//            .preferredColorScheme(.dark)
//            .previewDisplayName("Dark Mode")
//        }
//    }
//}
