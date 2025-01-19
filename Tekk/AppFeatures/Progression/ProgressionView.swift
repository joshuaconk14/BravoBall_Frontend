//
//  ProgressionView.swift
//  BravoBall
//
//  Created by Joshua Conklin on 1/17/25.
//

import SwiftUI
import RiveRuntime

struct ProgressionView: View {
    @ObservedObject var appModel: MainAppModel
    
    init(appModel: MainAppModel) {
        self.appModel = appModel
        appModel.configureNavigationBarAppearance()
    }

    var body: some View {
        NavigationView {
            content
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Progress")
                            .font(.custom("Poppins-Bold", size: 25))
                            .foregroundColor(.white)
                    }
                }
                .sheet(isPresented: $appModel.showDrillResults) {
                    DrillResultsView(appModel: appModel)
                }
        }
    }

    var content: some View {
        ScrollView(showsIndicators: false) {
            ZStack {
                // Base background colors
                VStack(spacing: 0) {
                    Color(appModel.globalSettings.primaryYellowColor)
                        .frame(height: 350)
                    Color.white
                }
                .ignoresSafeArea()
                
                VStack(spacing: 5) {
                    // Streak display
                    streakDisplay
                        .padding(.bottom, 30)
                    
                    // White background for calendar and stats
                    VStack(spacing: 5) {
                        // Calendar view
                        CalendarViewTest(appModel: appModel)
                        
                        // History display
                        HStack {
                            VStack {
                                if appModel.highestStreak == 1 {
                                    Text("\(appModel.highestStreak)  day")
                                        .font(.custom("Poppins-Bold", size: 30))
                                        .foregroundColor(appModel.globalSettings.primaryYellowColor)
                                } else {
                                    Text("\(appModel.highestStreak)  days")
                                        .font(.custom("Poppins-Bold", size: 30))
                                        .foregroundColor(appModel.globalSettings.primaryYellowColor)
                                }
                                Text("Highest Streak")
                                    .font(.custom("Poppins-Bold", size: 16))
                                    .foregroundColor(appModel.globalSettings.primaryGrayColor)
                            }
                            .padding()
                            
                            VStack {
                                Text("\(appModel.countOfFullyCompletedSessions)")
                                    .font(.custom("Poppins-Bold", size: 30))
                                    .foregroundColor(appModel.globalSettings.primaryYellowColor)
                                Text("Sessions completed")
                                    .font(.custom("Poppins-Bold", size: 16))
                                    .foregroundColor(appModel.globalSettings.primaryGrayColor)
                            }
                            .padding()
                        }
                    }
                    .padding(.horizontal)
                    .background(Color.white)
                    .cornerRadius(20, corners: [.topLeft, .topRight])
                }
            }
        }
    }

    // Streak display at the top
    private var streakDisplay: some View {
        VStack {
            HStack {
                Image("Streak_Flame")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                Text("\(appModel.currentStreak)")
                    .font(.custom("Poppins-Bold", size: 90))
                    .padding(.trailing, 20)
                    .foregroundColor(Color.white)
            }
            Text("Day Streak")
                .font(.custom("Poppins-Bold", size: 22))
                .foregroundColor(Color.white)
                .padding(.horizontal)
        }
        .padding()
    }

}



// MARK: Calendar View

struct CalendarViewTest: View {
    @ObservedObject var appModel: MainAppModel
    let calendar = Calendar.current
    
    // placeholder date
    @State private var selectedDate = Date()
    // production
    @State private var currentDate: Date = Date()
    // testing purposes
    @State private var simulatedDate: Date = Date()


    var body: some View {
        VStack {

            // Where we returns integers of specific date values called
            let days = calendar.daysInMonthTest(for: selectedDate)
            let today = Date()
            let firstWeekday = calendar.firstWeekdayInMonthTest(for: selectedDate)

            // Determines if moveMonth button can move or not
            let currentMonth = calendar.component(.month, from: selectedDate)
            let isCurrentOrFutureMonth = calendar.component(.month, from: today) >= currentMonth
            
            
            // Calendar header
            HStack {
                Text("Streak Calendar")
                    .font(.custom("Poppins-Bold", size: 22))
                    .foregroundColor(appModel.globalSettings.primaryGrayColor)
                
                Spacer()
                
                // Toggle full calendar button
                Button(action: {
                    withAnimation {
                        appModel.showCalendar.toggle()
                    }
                }) {
                    HStack {
                        Text(appModel.showCalendar ? "Month" : "Week")
                            .font(.custom("Poppins-Bold", size: 15))
                        Image(systemName: appModel.showCalendar ? "chevron.up" : "chevron.down")
                    }
                    .foregroundColor(appModel.globalSettings.primaryGrayColor)
                }
            }
            .padding(.vertical, 5)
            
            if appModel.inSimulationMode {
                testButton
            }

            // Month and Year header
            HStack {
                // Header
                if appModel.showCalendar {
                    // Left button
                    Button(action: { moveMonth(by: -1) }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(appModel.globalSettings.primaryGrayColor)
                    }
                    .foregroundColor(isCurrentOrFutureMonth ? appModel.globalSettings.primaryGrayColor.opacity(0.5) : appModel.globalSettings.primaryGrayColor)
                    .disabled(isCurrentOrFutureMonth)
                    
                    Spacer()
                    
                    Text(monthYearString(from: selectedDate))
                        .font(.custom("Poppins-Bold", size: 22))
                        .foregroundColor(appModel.globalSettings.primaryGrayColor)
                    
                    Spacer()
                    
                    // Right button
                    Button(action: { moveMonth(by: 1) }) {
                        Image(systemName: "chevron.right")
                            .foregroundColor(appModel.globalSettings.primaryGrayColor)
                    }
                    .foregroundColor(appModel.globalSettings.primaryGrayColor)
                    
                    
                } else {
                    Text(monthYearString(from: simulatedDate))
                        .font(.custom("Poppins-Bold", size: 22))
                        .foregroundColor(appModel.globalSettings.primaryGrayColor)
                }
            }
            .padding()

            // Day of week headers
            HStack(spacing: 25) {
                ForEach(["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"], id: \.self) { day in
                    Text(day)
                        .font(.custom("Poppins", size: 14))
                        .frame(maxWidth: .infinity)
                        .foregroundColor(appModel.globalSettings.primaryGrayColor)
                }
            }
            .padding(.horizontal, 8)

            // Calendar or week view
            if appModel.showCalendar {
                // Calendar grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 5) {

                    // Clear the unused days with no numbers
                    ForEach(0..<firstWeekday-1, id: \.self) { _ in
                        Color.clear
                            .frame(height: 50)

                    }

                    
                    ForEach(1...days, id: \.self) { day in

                        // Set dates for each displayed day
                        let fullDate = createFullDate(from: day)

                        WeekDisplayButton(
                            appModel: appModel,
                            text: "\(day)",
                            date: fullDate,
                            highlightedDay: isCurrentDay(day), /*calendar.isDateInToday(fullDate)*/ // works in production
                            session: appModel.getSessionForDate(fullDate)
                        )
                        .frame(height: 50)

                    }
                }
                .background(Color.white)
                
            } else {
                // Current week only
                HStack(spacing: 5) {
                    ForEach(daysInCurrentWeek(), id: \.date) { dayInfo in
                        WeekDisplayButton(
                            appModel: appModel,
                            text: "\(dayInfo.dayNumber)",
                            date: dayInfo.date,
                            highlightedDay: isCurrentDay(dayInfo.dayNumber), /*calendar.isDateInToday(dayInfo.date)*/ // works in production
                            session: appModel.getSessionForDate(dayInfo.date)
                        )
                        .frame(width: 45)
                    }
                }
                .background(Color.white)
            }
        }
        .padding()
//        .background(Color.white)
        .cornerRadius(10)
    }
    
    // MARK: Test Button
    
    private var testButton: some View {
        Group {
            if appModel.inSimulationMode {
                // test button
                Button(action: {
                    addDrill(for: simulatedDate)
                
                    // Increase or restart streak
                    if let session = appModel.getSessionForDate(simulatedDate) {
                        let score = Double(session.totalCompletedDrills) / Double(session.totalDrills)
                        if score == 0.0 {
                            appModel.currentStreak = 0
                        } else {
                            appModel.currentStreak += 1
                        }
                    }
                    
                    appModel.highestStreakSetter(streak: appModel.currentStreak)
                    simulateChangeOfDay()

                    if isLastDayOfMonth(date: simulatedDate) {
                        moveMonth(by: 1)
                    }


                }) {
                    Text("Test")
                        .foregroundColor(Color.black)
                        .font(.custom("Poppins-Bold", size: 13))
                        .foregroundColor(appModel.globalSettings.primaryGrayColor)
                }
    //            .padding(.horizontal)
            }
        }
    }


    // MARK: Calendar functions


    private func simulateChangeOfDay() {
        if let nextDay = calendar.date(byAdding: .day, value: 1, to: simulatedDate) {
            simulatedDate = nextDay
        }
    }



    private func addDrill(for date: Date) {
        let addedTestDrillsOne = MainAppModel.DrillData (
            name: "Cone weaves",
            skill: "Dribbling",
            duration: 20,
            sets: 4,
            reps: 8,
            equipment: ["Ball, cones"],
            isCompleted: Bool.random()
        )
        
        let addedTestDrillsTwo = MainAppModel.DrillData (
            name: "Toe-taps",
            skill: "Dribbling",
            duration: 10,
            sets: 3,
            reps: 20,
            equipment: ["Ball"],
            isCompleted: Bool.random()
        )
        
        let addedTestDrillsThree = MainAppModel.DrillData (
            name: "Ronaldinho Drill",
            skill: "Dribbling",
            duration: 15,
            sets: 4,
            reps: 3,
            equipment: ["Ball"],
            isCompleted: Bool.random()
        )
        
        let drills = [addedTestDrillsOne, addedTestDrillsTwo, addedTestDrillsThree]
        let completedDrillsCount = drills.filter { $0.isCompleted }.count

        appModel.addCompletedSession(date: simulatedDate, drills: drills, totalCompletedDrills: completedDrillsCount, totalDrills: drills.count)
    }

    private func createFullDate(from day: Int) -> Date {
            var components = calendar.dateComponents([.year, .month], from: selectedDate)
            components.day = day
            return calendar.date(from: components) ?? Date()
        }


    private func monthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter.string(from: date)
    }

    private func moveMonth(by months: Int) {
        if let newDate = calendar.date(byAdding: .month, value: months, to: selectedDate) {
            selectedDate = newDate
        }
    }

    private func isCurrentDay(_ day: Int) -> Bool {
        let dayMatches = calendar.component(.day, from: simulatedDate) == day
        let monthMatches = calendar.component(.month, from: simulatedDate) == calendar.component(.month, from: selectedDate)
        let yearMatches = calendar.component(.year, from: simulatedDate) == calendar.component(.year, from: selectedDate)

        return dayMatches && monthMatches && yearMatches
    }



    private func isLastDayOfMonth(date: Date) -> Bool {
        let day = calendar.component(.day, from: simulatedDate)
        guard let monthRange = calendar.range(of: .day, in: .month, for: simulatedDate) else { return false }
        let lastDay = monthRange.upperBound - 1
        return day == lastDay
    }
    
    
    // Current week structure
    private struct DayInfo {
        let date: Date
        let dayNumber: Int
    }
    
    // Retrieving the current week
    private func daysInCurrentWeek() -> [DayInfo] {
        let calendar = Calendar.current
        
        // Returning the start of the week for the present date
        guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: simulatedDate)
            ) else {
                return []
        }
        
        // Returning the days of the week, each day given its own DayInfo structure
        return (0...6).map { dayOffset in
            let date = calendar.date(byAdding: .day, value: dayOffset, to: startOfWeek) ?? simulatedDate
            let dayNumber = calendar.component(.day, from: date)
            return DayInfo(date: date, dayNumber: dayNumber)
        }
    }

}

// Extensions for calendar view
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

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

#Preview {
    let mockAppModel = MainAppModel()
    return ProgressionView(appModel: mockAppModel)
}
