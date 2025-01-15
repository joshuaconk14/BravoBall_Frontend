import SwiftUI
import RiveRuntime

struct TestCompSesView: View {
    @ObservedObject var mainAppModel: MainAppModel
    @State var selectedDate = Date()
    let calendar = Calendar.current
    
    // For real date tracking
    @State private var lastCheckedDate: Date = Date()
    
    // For testing/simulation
    @State private var simulatedCurrentDate: Date = Date()
    @State private var isSimulationMode: Bool = true // Toggle this for testing vs real
    
    private func getCurrentDate() -> Date {
        return isSimulationMode ? simulatedCurrentDate : Date()
    }
    
    private func simulateNextDay() {
        if let nextDay = calendar.date(byAdding: .day, value: 1, to: simulatedCurrentDate) {
            simulatedCurrentDate = nextDay
            addCompletedSession(for: simulatedCurrentDate)
        }
    }
    
    private func addCompletedSession(for date: Date) {
        let testDrill = MainAppModel.DrillData(
            name: "Test Drill",
            skill: "Test Skill",
            duration: 30,
            sets: 3,
            reps: 10,
            equipment: ["Ball"]
        )
        mainAppModel.addCompleteSession(date: date, drills: [testDrill])
        mainAppModel.streakIncrease += 1
    }
    
    private func checkForNewDay() {
        let currentDate = Date()
        if !calendar.isDate(lastCheckedDate, inSameDayAs: currentDate) {
            // A new day has started
            addCompletedSession(for: lastCheckedDate) // Add session for the day that just passed
            lastCheckedDate = currentDate
        }
    }
    
    var body: some View {
        VStack {
            // Current date display
            if isSimulationMode {
                Text("Simulated Date: \(simulatedCurrentDate, style: .date)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            // Test button (only shown in simulation mode)
            if isSimulationMode {
                Button(action: {
                    simulateNextDay()
                }) {
                    Text("Simulate Next Day")
                        .foregroundColor(.blue)
                }
                .padding()
            }
            
            // Calendar UI
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 5) {
                let days = calendar.range(of: .day, in: .month, for: selectedDate)?.count ?? 0
                let firstWeekday = calendar.component(.weekday, from: startOfMonth(for: selectedDate))
                
                // Empty spaces for days before the first of the month
                ForEach(0..<(firstWeekday - 1), id: \.self) { _ in
                    Color.clear
                        .frame(height: 50)
                }
                
                // Days of the month
                ForEach(1...days, id: \.self) { day in
                    let components = calendar.dateComponents([.year, .month], from: selectedDate)
                    var dayComponents = DateComponents()
                    dayComponents.year = components.year
                    dayComponents.month = components.month
                    dayComponents.day = day
                    
                    if let dayDate = calendar.date(from: dayComponents) {
                        WeekDisplayButton(
                            mainAppModel: mainAppModel,
                            date: dayDate,
                            text: "\(day)",
                            dayWithScore: mainAppModel.isDayCompleted(dayDate),
                            highlightedDay: calendar.isDateInToday(dayDate)
                        )
                        .frame(height: 50)
                    }
                }
            }
        }
        .padding()
        .onAppear {
            // Initialize dates
            lastCheckedDate = Date()
            simulatedCurrentDate = Date()
        }
        .onChange(of: Date()) { _ in
            // This will trigger every time the real date changes
            if !isSimulationMode {
                checkForNewDay()
            }
        }
    }
    
    private func startOfMonth(for date: Date) -> Date {
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components) ?? date
    }
    
    private func createFullDate(from day: Int) -> Date {
        var components = calendar.dateComponents([.year, .month], from: selectedDate)
        components.day = day
        return calendar.date(from: components) ?? Date()
    }
    
    private func getDateComponents(from date: Date) -> (day: Int, month: Int, year: Int) {
        let components = calendar.dateComponents([.day, .month, .year], from: date)
        return (
            day: components.day ?? 1,
            month: components.month ?? 1,
            year: components.year ?? 2024
        )
    }
    
    private func getCurrentMonthYear() -> (month: Int, year: Int) {
        let currentDate = isSimulationMode ? simulatedCurrentDate : Date()
        let components = calendar.dateComponents([.month, .year], from: currentDate)
        return (month: components.month ?? 1, year: components.year ?? 2024)
    }
}

#Preview {
    let mockAppModel = MainAppModel()
    return TestCompSesView(mainAppModel: mockAppModel)
} 