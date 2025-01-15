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
//
//    @ObservedObject var mainAppModel: MainAppModel
//    @State private var showCalendar = false
//
//    var body: some View {
//        content
//            .sheet(isPresented: $mainAppModel.showDrillShower) {
//                DrillResultsView(mainAppModel: mainAppModel)
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
//                // Add Calendar Button
//                Button(action: {
//                    withAnimation {
//                        showCalendar.toggle()
//                    }
//                }) {
//                    HStack {
//                        Text("View Calendar")
//                            .font(.custom("Poppins-Bold", size: 16))
//                        Image(systemName: showCalendar ? "chevron.up" : "chevron.down")
//                    }
//                    .foregroundColor(mainAppModel.globalSettings.primaryDarkColor)
//                    .padding()
//                }
//                
//                // Calendar View (appears when showCalendar is true)
//                if showCalendar {
//                    CalendarViewTest(mainAppModel: mainAppModel)
//                        .frame(height: 300)
//                        .padding(.top, 35)
//                        .transition(.move(edge: .top))
//                }
//            }
//            .padding(.horizontal)
//        }
//    }
//    
//    
//    
//    private var streakDisplay: some View {
//        ZStack {
//            RiveViewModel(fileName: "Streak_Diamond").view()
//                .aspectRatio(contentMode: .fit)  // For diff screen width so object does not go out screen
//                .frame(maxWidth: .infinity)
//                .padding()
//            HStack {
//                Image("Streak_Flame")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 80, height: 80)
//                Text("\(mainAppModel.streakIncrease)")
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
//
//// MARK: Calendar
//
//
//
//struct CalendarViewTest: View {
//    @ObservedObject var mainAppModel: MainAppModel
//    @State var selectedDate = Date() // placeholder date
//    let calendar = Calendar.current
//    
//    @State private var todayInt: Int = 0
//    @State private var startDate: Int = 0
//    
//    // production
//    @State private var lastCheckedDate: Date = Date()
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
//            let currentMonth = calendar.component(.month, from: selectedDate)
////            let currentYear = calendar.component(.year, from: selectedDate)
////            let isCurrentMonth = calendar.component(.month, from: today) == currentMonth &&
////                                calendar.component(.year, from: today) == currentYear
//            let isCurrentOrFutureMonth = calendar.component(.month, from: today) >= currentMonth
//            
//            
//            if inSimulationMode {
//                // test button
//                Button(action: {
//                    addDrill(for: simulatedDate)
//                    mainAppModel.streakIncrease += 1
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
//                .foregroundColor(isCurrentOrFutureMonth ? mainAppModel.globalSettings.primaryDarkColor.opacity(0.5) : mainAppModel.globalSettings.primaryDarkColor)
//                .disabled(isCurrentOrFutureMonth)
//                
//                Button(action: { moveMonth(by: 1) }) {
//                    Image(systemName: "chevron.right")
//                }
//                .foregroundColor(mainAppModel.globalSettings.primaryDarkColor)
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
//       
//            
//            // Calendar grid
//            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 5) {
//                
//                ForEach(0..<firstWeekday-1, id: \.self) { _ in
//                    Color.clear
//                        .frame(height: 50)
//                
//                }
//                
//                ForEach(1...days, id: \.self) { day in
//
//                    let fullDate = createFullDate(from: day)
//                    
//                    WeekDisplayButton(
//                        mainAppModel: mainAppModel,
//                        text: "\(day)",
//                        date: fullDate,
//                        dayWithScore: mainAppModel.isDayCompleted(fullDate),
//                        highlightedDay: isCurrentDay(day)
//                    )
//                    .frame(height: 50)
//                        
//                }
//            }
//        }
//        .padding()
//        .background(Color.white)
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
//        let addedTestDrills = MainAppModel.DrillData (
//            name: "Cone weaves",
//            skill: "Dribbling",
//            duration: 20,
//            sets: 4,
//            reps: 8,
//            equipment: ["Ball, cones"]
//        )
//        
//        mainAppModel.addCompleteSession(date: simulatedDate, drills: [addedTestDrills])
//    }
//    
//    private func createFullDate(from day: Int) -> Date {
//            var components = calendar.dateComponents([.year, .month], from: selectedDate)
//            components.day = day
//            return calendar.date(from: components) ?? Date()
//        }
//        
//    private func getDateComponents(from date: Date) -> (day: Int, month: Int, year: Int) {
//        let components = calendar.dateComponents([.day, .month, .year], from: date)
//        return (
//            day: components.day ?? 1,
//            month: components.month ?? 1,
//            year: components.year ?? 2024
//        )
//    }
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
//    return testCompSesView(mainAppModel: mockAppModel)
//}
//
