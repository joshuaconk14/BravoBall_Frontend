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
                                            .foregroundColor(sessionModel.isDrillLiked(drill) ? .red : appModel.globalSettings.primaryDarkColor)  // Stroke color
                                            .frame(width: 30, height: 30)
                                    )
                            }
                            
                            Button(action: {
                                showSaveDrill = true
                            }) {
                                Image(systemName: "square.and.arrow.down")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(appModel.globalSettings.primaryDarkColor)
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
                                .foregroundColor(appModel.globalSettings.primaryDarkColor)
                            
                            HStack(spacing: 16) {
                                Label("\(drill.sets)" + " sets", systemImage: "repeat")
                                Label("\(drill.reps)" + " reps", systemImage: "figure.run")
                                Label("\(drill.duration)" + " minutes", systemImage: "clock")
                            }
                            .font(.custom("Poppins-Medium", size: 14))
                            .foregroundColor(appModel.globalSettings.primaryDarkColor)
                        }
                        
                        // Description
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.custom("Poppins-Bold", size: 18))
                                .foregroundColor(appModel.globalSettings.primaryDarkColor)
                            Text(drill.description)
                                .font(.custom("Poppins-Regular", size: 16))
                                .foregroundColor(appModel.globalSettings.primaryGrayColor)
                        }
                        
                        // Tips
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Tips")
                                .font(.custom("Poppins-Bold", size: 18))
                                .foregroundColor(appModel.globalSettings.primaryDarkColor)
                            ForEach(drill.tips, id: \.self) { tip in
                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                    Text(tip)
                                        .font(.custom("Poppins-Regular", size: 16))
                                        .foregroundColor(appModel.globalSettings.primaryGrayColor)
                                }
                            }
                        }
                        
                        // Equipment needed
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Equipment Needed")
                                .font(.custom("Poppins-Bold", size: 18))
                                .foregroundColor(appModel.globalSettings.primaryDarkColor)
                            ForEach(drill.equipment, id: \.self) { item in
                                HStack(spacing: 8) {
                                    Image(systemName: "circle.fill")
                                        .font(.system(size: 6))
                                        .foregroundColor(.gray)
                                    Text(item)
                                        .font(.custom("Poppins-Regular", size: 16))
                                        .foregroundColor(appModel.globalSettings.primaryGrayColor)
                                }
                            }
                        }
                    }
                    .padding()
                }
                
                if showSaveDrill {
                    findGroupToSaveToView
                }
                
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




// TODO: make this better code


// MARK: Editing Drill VIew
struct EditingDrillView: View {
    
    @ObservedObject var appModel: MainAppModel
    @ObservedObject var sessionModel: SessionGeneratorModel
    @Binding var editableDrill: EditableDrillModel
    
    @State private var showDrillDetailView: Bool = false
    @State private var editSets: String = ""
    @State private var editReps: String = ""
    @State private var editDuration: String = ""
    @FocusState private var isSetsFocused: Bool
    @FocusState private var isRepsFocused: Bool
    @FocusState private var isDurationFocused: Bool
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    
                    Spacer()
                    
                    // Progress header
                    Text("Edit Drill")
                        .font(.custom("Poppins-Bold", size: 18))
                        .foregroundColor(.black)
                        .padding()
                    
                    Spacer()
                    
                    Button(action : {
                        showDrillDetailView = true
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .foregroundColor(appModel.globalSettings.primaryDarkColor)
                            .font(.system(size: 16, weight: .medium))
                    }
                    .padding()
                }
                
                ZStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.1))
                        .aspectRatio(16/9, contentMode: .fit)
                        .cornerRadius(12)
                    
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 25) {
                    HStack {
                        TextField("\(editableDrill.totalSets)", text: $editSets)
                            .keyboardType(.numberPad)
                            .textFieldStyle(PlainTextFieldStyle())
                            .font(.custom("Poppins-Medium", size: 18))
                            .foregroundColor(appModel.globalSettings.primaryDarkColor)
                            .focused($isSetsFocused)
                            .tint((appModel.globalSettings.primaryYellowColor))
                            .frame(maxWidth: 60)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 8)
                            .onChange(of: editSets) { _, newValue in
                                            let filtered = newValue.filter { $0.isNumber }
                                            if filtered.count > 2 {
                                                // Limit to 2 digits
                                                editSets = String(filtered.prefix(2))
                                            } else if filtered != newValue {
                                                // Only numbers allowed
                                                editSets = filtered
                                            }

                                        }
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(isSetsFocused ? appModel.globalSettings.primaryYellowColor : appModel.globalSettings.primaryLightGrayColor, lineWidth: 3)
                            )
                        Text("Sets")
                            .font(.custom("Poppins-Medium", size: 18))
                            .foregroundColor(appModel.globalSettings.primaryDarkColor)
                    }
                    HStack {
                        TextField("\(editableDrill.totalReps)", text: $editReps)
                            .keyboardType(.numberPad)
                            .textFieldStyle(PlainTextFieldStyle())
                            .font(.custom("Poppins-Medium", size: 18))
                            .foregroundColor(appModel.globalSettings.primaryDarkColor)
                            .focused($isRepsFocused)
                            .tint((appModel.globalSettings.primaryYellowColor))
                            .frame(maxWidth: 60)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 8)
                            .onChange(of: editSets) { _, newValue in
                                            let filtered = newValue.filter { $0.isNumber }
                                            if filtered.count > 2 {
                                                // Limit to 2 digits
                                                editSets = String(filtered.prefix(2))
                                            } else if filtered != newValue {
                                                // Only numbers allowed
                                                editSets = filtered
                                            }

                                        }
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(isRepsFocused ? appModel.globalSettings.primaryYellowColor : appModel.globalSettings.primaryLightGrayColor, lineWidth: 3)
                            )
                        Text("Reps")
                            .font(.custom("Poppins-Medium", size: 18))
                            .foregroundColor(appModel.globalSettings.primaryDarkColor)
                    }
                    HStack {
                        TextField("\(editableDrill.totalDuration)", text: $editDuration)
                            .keyboardType(.numberPad)
                            .textFieldStyle(PlainTextFieldStyle())
                            .font(.custom("Poppins-Medium", size: 18))
                            .foregroundColor(appModel.globalSettings.primaryDarkColor)
                            .focused($isDurationFocused)
                            .tint((appModel.globalSettings.primaryYellowColor))
                            .frame(maxWidth: 60)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 8)
                            .onChange(of: editSets) { _, newValue in
                                            let filtered = newValue.filter { $0.isNumber }
                                            if filtered.count > 2 {
                                                // Limit to 2 digits
                                                editSets = String(filtered.prefix(2))
                                            } else if filtered != newValue {
                                                // Only numbers allowed
                                                editSets = filtered
                                            }

                                        }
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(isDurationFocused ? appModel.globalSettings.primaryYellowColor : appModel.globalSettings.primaryLightGrayColor, lineWidth: 3)
                            )
                        Text("Minutes")
                            .font(.custom("Poppins-Medium", size: 18))
                            .foregroundColor(appModel.globalSettings.primaryDarkColor)
                    }
                    
                }
                .padding(.bottom, 100)
                
                Spacer()
            }
            .padding()
            
        }
        
        .sheet(isPresented: $showDrillDetailView) {
            DrillDetailView(appModel: appModel, sessionModel: sessionModel, drill: editableDrill.drill)
        }
        
        // TODO: fix this
        .safeAreaInset(edge: .bottom) {
            let validations = (
                sets: Int(editSets).map { $0 > 0 && $0 <= 99 } ?? false,
                reps: Int(editReps).map { $0 > 0 && $0 <= 99 } ?? false,
                duration: Int(editDuration).map { $0 > 0 && $0 <= 999 } ?? false
            )
            
            let allValid = validations.sets || validations.reps || validations.duration
            
            Button(action: {
                if let sets = Int(editSets),
                   let reps = Int(editReps),
                   let duration = Int(editDuration),
                   allValid {
                    editableDrill.totalSets = sets
                    editableDrill.totalReps = reps
                    editableDrill.totalDuration = duration
                }
            }) {
                Text("Save Changes")
                    .font(.custom("Poppins-Bold", size: 18))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(allValid ? appModel.globalSettings.primaryYellowColor : Color.gray.opacity(0.5))
                    .cornerRadius(12)
            }
            .disabled(!allValid)
            .padding()
        }
    }
}


#Preview {
    let mockDrill = EditableDrillModel(
        drill: DrillModel(
            title: "Test Drill",
            skill: "Passing",
            sets: 2,
            reps: 10,
            duration: 15,
            description: "Test description",
            tips: ["Tip 1", "Tip 2"],
            equipment: ["Ball"],
            trainingStyle: "Medium Intensity",
            difficulty: "Beginner"
        ),
        setsDone: 0,
        totalSets: 2,
        totalReps: 10,
        totalDuration: 15,
        isCompleted: false
    )
    
    return EditingDrillView(
        appModel: MainAppModel(),
        sessionModel: SessionGeneratorModel(onboardingData: OnboardingModel.OnboardingData()),
        editableDrill: .constant(mockDrill)
    )
}
