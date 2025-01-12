//
//  testCompSesView.swift
//  BravoBall
//
//  Created by Joshua Conklin on 1/11/25.
//

//
//  CompletedSessionView.swift
//  BravoBall
//
//  Created by Joshua Conklin on 1/10/25.
//

import SwiftUI
import RiveRuntime

struct testCompSesView: View {
    @ObservedObject var mainAppModel: MainAppModel
    @State private var showCalendar = false

    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 5) {
                
                streakDisplay
                
                
                Text("Completed drills:")
                    .font(.custom("Poppins-Bold", size: 18))
                    .padding(.bottom, 5)
                Text("Completed exercises:")
                    .font(.custom("Poppins-Bold", size: 18))
                    .padding(.bottom, 10)
                
                
                
                
                
//                // test button
//                Button(action: {
//                    if mainAppModel.currentDay >= 0 {
//                        mainAppModel.completedSessionIndicator()
//                        mainAppModel.addCheckMark = true
//                        mainAppModel.streakIncrease += 1
//                        mainAppModel.interactedDayShowGreen = true
//                    }
//                }) {
//                    Text("Test")
//                        .foregroundColor(Color.blue)
//                }
//                .padding(.horizontal)
//                .padding(.bottom, 20)
                
                
                // week changer
                HStack {
                    Button(action: {
                        mainAppModel.currentWeek -= 1
                    }) {
                        Image(systemName: "chevron.left")
                            .frame(minWidth: 44, minHeight: 44)
                    }
                    .foregroundColor(mainAppModel.globalSettings.primaryDarkColor)
                    .padding(.trailing, 10)
                    .disabled(mainAppModel.currentWeek == 0)
                    
                    Text("Week \(mainAppModel.currentWeek + 1)")
                        .font(.custom("Poppins-Bold", size: 23))
                    
                    Button(action: {
                        mainAppModel.currentWeek += 1
                    }) {
                        Image(systemName: "chevron.right")
                            .frame(minWidth: 44, minHeight: 44)
                    }
                    .foregroundColor(mainAppModel.globalSettings.primaryDarkColor)
                    .padding(.leading, 10)
                    .disabled(mainAppModel.currentWeek == mainAppModel.completedWeeks.count)
                }
                .padding(.bottom, 15)
                
                
                HStack(spacing: 32) {
                    Text("Su")
                    Text("Mo")
                    Text("Tu")
                    Text("We")
                    Text("Th")
                    Text("Fr")
                    Text("Sa")
                }
                .font(.custom("Poppins", size: 20))
                .padding(.bottom, 20)
                .foregroundColor(mainAppModel.globalSettings.primaryDarkColor)
                
                
                // For each week display button:
                HStack(spacing: 0) {
                    ForEach(0..<7) { index in
                        WeekDisplayButton(
                            mainAppModel: mainAppModel,
                            text: getDayText(for: index),
                            dayWithScore: mainAppModel.currentDay > index, // boolean goes through each index / case #
                            highlightedDay: mainAppModel.currentDay + 1 > index // boolean goes through each index / case #
                        )
                    }
                }
                // Add Calendar Button
                Button(action: {
                    withAnimation {
                        showCalendar.toggle()
                    }
                }) {
                    HStack {
                        Text("View Calendar")
                            .font(.custom("Poppins-Bold", size: 16))
                        Image(systemName: showCalendar ? "chevron.up" : "chevron.down")
                    }
                    .foregroundColor(mainAppModel.globalSettings.primaryDarkColor)
                    .padding()
                }
                
                // Calendar View (appears when showCalendar is true)
                if showCalendar {
                    CalendarViewTest(mainAppModel: mainAppModel)
                        .frame(height: 300)
                        .padding(.top, 35)
                        .transition(.move(edge: .top))
                }
            }
            .padding(.horizontal)
        }
    }
    
    
    
    private var streakDisplay: some View {
        ZStack {
            RiveViewModel(fileName: "Streak_Diamond").view()
                .aspectRatio(contentMode: .fit)  // For diff screen width so object does not go out screen
                .frame(maxWidth: .infinity)
                .padding()
            HStack {
                Image("Streak_Flame")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                Text("\(mainAppModel.streakIncrease)")
                    .font(.custom("Poppins-Bold", size: 70))
                    .padding(.trailing, 20)
                    .foregroundColor(.red)
            }
        }
        .padding()
    }
    
    // returns the text for each day
    private func getDayText(for index: Int) -> String {
        switch index {
        case 0: return "1"
        case 1: return "2"
        case 2: return "3"
        case 3: return "4"
        case 4: return "5"
        case 5: return "6"
        case 6: return "7"
        default: return ""
        }
    }
}


// MARK: Calendar

struct CalendarViewTest: View {
    @ObservedObject var mainAppModel: MainAppModel
    @State var selectedDate = Date()
    let calendar = Calendar.current
    
    @State private var todayInt: Int = 0
    
    
    
    var body: some View {
        VStack {
            
            // initializing present day date as an Int
            Spacer()
                .onAppear {
                    todayInt = calendar.component(.day, from: selectedDate)
            }
            
            // test button
            Button(action: {
                if todayInt >= 0 {
                    todayInt += 1
                    mainAppModel.addCheckMark = true
                    mainAppModel.streakIncrease += 1
                    mainAppModel.interactedDayShowGreen = true
                }
            }) {
                Text("Test")
                    .foregroundColor(Color.blue)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
            
            
            
            // Month and Year header
            HStack {
                Text(monthYearString(from: selectedDate))
                    .font(.custom("Poppins-Bold", size: 18))
                Spacer()
                
                Button(action: { moveMonth(by: -1) }) {
                    Image(systemName: "chevron.left")
                }
                .foregroundColor(mainAppModel.globalSettings.primaryDarkColor)
                
                Button(action: { moveMonth(by: 1) }) {
                    Image(systemName: "chevron.right")
                }
                .foregroundColor(mainAppModel.globalSettings.primaryDarkColor)
            }
            .padding()
            
            // Day of week headers
            HStack {
                ForEach(["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"], id: \.self) { day in
                    Text(day)
                        .font(.custom("Poppins", size: 14))
                        .frame(maxWidth: .infinity)
                }
            }
            
            // Calendar grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 5) {
                let days = calendar.daysInMonthTest(for: selectedDate)
                let firstWeekday = calendar.firstWeekdayInMonthTest(for: selectedDate)
                
                ForEach(0..<firstWeekday-1, id: \.self) { _ in
                    Color.clear
                        .frame(height: 50)
                }
                
                ForEach(1...days, id: \.self) { day in
                    WeekDisplayButton(
                        mainAppModel: mainAppModel,
                        text: "\(day)",
                        dayWithScore: todayInt > day,
                        highlightedDay: /*isCurrentDay(day)*/ todayInt + 1 > day
                    )
                    .frame(height: 50)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
    }
    
    private func monthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
    
    private func moveMonth(by months: Int) {
        if let newDate = calendar.date(byAdding: .month, value: months, to: selectedDate) {
            selectedDate = newDate
        }
    }
    
    private func isCurrentDay(_ day: Int) -> Bool {
        let today = Date()
        let dayMatches = calendar.component(.day, from: today) == day
        let monthMatches = calendar.component(.month, from: today) == calendar.component(.month, from: selectedDate)
        let yearMatches = calendar.component(.year, from: today) == calendar.component(.year, from: selectedDate)
        
        return dayMatches && monthMatches && yearMatches
    }
}

extension Calendar {
    func daysInMonthTest(for date: Date) -> Int {
        return range(of: .day, in: .month, for: date)?.count ?? 0
    }
    
    func firstWeekdayInMonthTest(for date: Date) -> Int {
        let components = dateComponents([.year, .month], from: date)
        guard let firstDay = self.date(from: components) else { return 1 }
        return component(.weekday, from: firstDay)
    }
}



#Preview {
    let mockAppModel = MainAppModel()
    return testCompSesView(mainAppModel: mockAppModel)
}
