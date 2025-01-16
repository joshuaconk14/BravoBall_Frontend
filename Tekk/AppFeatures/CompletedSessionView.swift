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

//import SwiftUI
//import RiveRuntime
//
//struct testCompSesView: View {
//    @ObservedObject var appModel: MainAppModel
//
//    var body: some View {
//        content
//            .sheet(isPresented: $appModel.showDrillResults) {
//                DrillResultsView(appModel: appModel)
//            }
//    }
//
//    var content: some View {
//        ScrollView(showsIndicators: false) {
//            VStack(spacing: 5) {
//
//                streakDisplay
//
//
//
//                // Toggle full calendar
//                Button(action: {
//                    withAnimation {
//                        appModel.showCalendar.toggle()
//                    }
//                }) {
//                    HStack {
//                        Text(appModel.showCalendar ? "View Week" : "View Calendar")
//                            .font(.custom("Poppins-Bold", size: 16))
//                        Image(systemName: appModel.showCalendar ? "chevron.up" : "chevron.down")
//                    }
//                    .foregroundColor(appModel.globalSettings.primaryDarkColor)
//                    .padding()
//                }
//                    
//                // Calendar view
//                CalendarViewTest(appModel: appModel)
//                        
//
//            }
//            .padding(.horizontal)
//        }
//    }
//
//    // Streak display at the top
//    private var streakDisplay: some View {
//        ZStack {
//            RiveViewModel(fileName: "Streak_Diamond").view()
//                .aspectRatio(contentMode: .fit)
//                .frame(maxWidth: .infinity)
//                .padding()
//            HStack {
//                Image("Streak_Flame")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 80, height: 80)
//                Text("\(appModel.streakIncrease)")
//                    .font(.custom("Poppins-Bold", size: 70))
//                    .padding(.trailing, 20)
//                    .foregroundColor(.red)
//            }
//        }
//        .padding()
//    }
//
//}
//
//
//
//// MARK: Calendar View
//
//struct CalendarViewTest: View {
//    @ObservedObject var appModel: MainAppModel
//    let calendar = Calendar.current
//    
//    // placeholder date
//    @State var selectedDate = Date()
//
//    // production
//    @State private var currentDate: Date = Date()
//
//    // testing purposes
//    @State private var simulatedDate: Date = Date()
//    @State private var inSimulationMode: Bool = true
//
//    // TODO: format code in easy simulation / production switch, this is key for this page
//
//
//    var body: some View {
//        VStack {
//
//            // Where we returns integers of specific date values called
//            let days = calendar.daysInMonthTest(for: selectedDate)
//            let today = Date()
//            let firstWeekday = calendar.firstWeekdayInMonthTest(for: selectedDate)
//
//            // Determines if moveMonth button can move or not
//            let currentMonth = calendar.component(.month, from: selectedDate)
//            let isCurrentOrFutureMonth = calendar.component(.month, from: today) >= currentMonth
//
//
//            if inSimulationMode {
//                // test button
//                Button(action: {
//                    addDrill(for: simulatedDate)
//                    appModel.streakIncrease += 1
//                    simulateChangeOfDay()
//
//                    if isLastDayOfMonth(date: simulatedDate) {
//                        moveMonth(by: 1)
//                    }
//
//
//                }) {
//                    Text("Test")
//                        .foregroundColor(Color.blue)
//                }
//                .padding(.horizontal)
//                .padding(.bottom, 20)
//            }
//
//
//
//
//            // Month and Year header
//            HStack {
//                Text(monthYearString(from: selectedDate))
//                    .font(.custom("Poppins-Bold", size: 18))
//                Spacer()
//
//                Button(action: { moveMonth(by: -1) }) {
//                    Image(systemName: "chevron.left")
//                }
//                .foregroundColor(isCurrentOrFutureMonth ? appModel.globalSettings.primaryDarkColor.opacity(0.5) : appModel.globalSettings.primaryDarkColor)
//                .disabled(isCurrentOrFutureMonth)
//
//                Button(action: { moveMonth(by: 1) }) {
//                    Image(systemName: "chevron.right")
//                }
//                .foregroundColor(appModel.globalSettings.primaryDarkColor)
//            }
//            .padding()
//
//            // Day of week headers
//            HStack {
//                ForEach(["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"], id: \.self) { day in
//                    Text(day)
//                        .font(.custom("Poppins", size: 14))
//                        .frame(maxWidth: .infinity)
//                }
//            }
//            .padding()
//
//            // Calendar or week view
//            if appModel.showCalendar {
//                // Calendar grid
//                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 5) {
//
//                    // Clear the unused days with no numbers
//                    ForEach(0..<firstWeekday-1, id: \.self) { _ in
//                        Color.clear
//                            .frame(height: 50)
//
//                    }
//
//                    
//                    ForEach(1...days, id: \.self) { day in
//
//                        let fullDate = createFullDate(from: day)
//
//                        WeekDisplayButton(
//                            appModel: appModel,
//                            text: "\(day)",
//                            date: fullDate,
//                            dayWithScore: appModel.isDayCompleted(fullDate),
//                            highlightedDay: /*isCurrentDay(day)*/ calendar.isDateInToday(fullDate) // works in production
//                        )
//                        .frame(height: 50)
//
//                    }
//                }
//                .background(Color.white)
//                
//            } else {
//                // Current week only
//                HStack(spacing: 5) {
//                    ForEach(daysInCurrentWeek(), id: \.date) { dayInfo in
//                        WeekDisplayButton(
//                            appModel: appModel,
//                            text: "\(dayInfo.dayNumber)",
//                            date: dayInfo.date,
//                            dayWithScore: appModel.isDayCompleted(dayInfo.date),
//                            highlightedDay: calendar.isDateInToday(dayInfo.date) // works in production
//                        )
//                        .frame(width: 45)
//                    }
//                }
//                .background(Color.white)
//            }
//        }
//        .padding()
////        .background(Color.white)
//        .cornerRadius(10)
//    }
//
//
//    // MARK: Calendar functions
//
//    private func getCurrentDate() -> Date {
//        return inSimulationMode ? simulatedDate: Date()
//    }
//
//    private func simulateChangeOfDay() {
//        if let nextDay = calendar.date(byAdding: .day, value: 1, to: simulatedDate) {
//            simulatedDate = nextDay
//        }
//    }
//
//
//
//    private func addDrill(for date: Date) {
//        let addedTestDrillsOne = MainAppModel.DrillData (
//            name: "Cone weaves",
//            skill: "Dribbling",
//            duration: 20,
//            sets: 4,
//            reps: 8,
//            equipment: ["Ball, cones"]
//        )
//        
//        let addedTestDrillsTwo = MainAppModel.DrillData (
//            name: "Toe-taps",
//            skill: "Dribbling",
//            duration: 10,
//            sets: 3,
//            reps: 20,
//            equipment: ["Ball"]
//        )
//        
//        let addedTestDrillsThree = MainAppModel.DrillData (
//            name: "Ronaldinho Drill",
//            skill: "Dribbling",
//            duration: 15,
//            sets: 4,
//            reps: 3,
//            equipment: ["Ball"]
//        )
//
//        appModel.addCompleteSession(date: simulatedDate, drills: [addedTestDrillsOne, addedTestDrillsTwo, addedTestDrillsThree])
//    }
//
//    private func createFullDate(from day: Int) -> Date {
//            var components = calendar.dateComponents([.year, .month], from: selectedDate)
//            components.day = day
//            return calendar.date(from: components) ?? Date()
//        }
//
//
//    private func monthYearString(from date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MMMM yyyy"
//        return formatter.string(from: date)
//    }
//
//    private func moveMonth(by months: Int) {
//        if let newDate = calendar.date(byAdding: .month, value: months, to: selectedDate) {
//            selectedDate = newDate
//        }
//    }
//
//    private func isCurrentDay(_ day: Int) -> Bool {
//        let dayMatches = calendar.component(.day, from: simulatedDate) == day
//        let monthMatches = calendar.component(.month, from: simulatedDate) == calendar.component(.month, from: selectedDate)
//        let yearMatches = calendar.component(.year, from: simulatedDate) == calendar.component(.year, from: selectedDate)
//
//        return dayMatches && monthMatches && yearMatches
//    }
//
//
//
//    private func isLastDayOfMonth(date: Date) -> Bool {
//        let day = calendar.component(.day, from: simulatedDate)
//        guard let monthRange = calendar.range(of: .day, in: .month, for: simulatedDate) else { return false }
//        let lastDay = monthRange.upperBound - 1
//        return day == lastDay
//    }
//    
//    
//    // Retrieving the current week
//    private struct DayInfo {
//        let date: Date
//        let dayNumber: Int
//    }
//    
//    private func daysInCurrentWeek() -> [DayInfo] {
//        let calendar = Calendar.current
//        
//        // Returning the start of the week for the present date
//        guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: simulatedDate)) else {
//            return []
//        }
//        
//        // Returning the days of the week to the DayInfo structure
//        return (0...6).map { dayOffset in
//            let date = calendar.date(byAdding: .day, value: dayOffset, to: startOfWeek) ?? simulatedDate
//            let dayNumber = calendar.component(.day, from: date)
//            return DayInfo(date: date, dayNumber: dayNumber)
//        }
//    }
//
//}
//
//extension Calendar {
//    func daysInMonthTest(for date: Date) -> Int {
//        return range(of: .day, in: .month, for: date)?.count ?? 0
//    }
//
//    func firstWeekdayInMonthTest(for date: Date) -> Int {
//        let components = dateComponents([.year, .month], from: date)
//        guard let firstDay = self.date(from: components) else { return 1 }
//        return component(.weekday, from: firstDay)
//    }
//}
//
//
//
//#Preview {
//    let mockAppModel = MainAppModel()
//        return testCompSesView(appModel: mockAppModel)
//}
//
