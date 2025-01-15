class MainAppModel: ObservableObject {
    let globalSettings = GlobalSettings()
    
    @Published var mainTabSelected = 0
    @Published var currentProgress = 0
    @Published var addCheckMark = false
    @Published var streakIncrease: Int = 0
    @Published var interactedDay = false
    @Published var currentWeek = 0
    @Published var completedWeeks: [WeekData] = [WeekData()]
    
    @Published var showAlert = false
    @Published var alertType: AlertType = .none
    
    struct WeekData {
        var weekNumber: Int = 1
        var progress: Int = 0
        var isCompleted: Bool = false
    }
    
    func getProgressForCurrentWeek() -> Int {
        guard currentWeek < completedWeeks.count else { return 0 }
        return completedWeeks[currentWeek].progress
    }
    
    func completeDay() {
        guard currentWeek < completedWeeks.count else { return }
        
        if completedWeeks[currentWeek].progress >= 6 {
            let newWeek = WeekData(weekNumber: completedWeeks.count + 1)
            completedWeeks.append(newWeek)
            completedWeeks[currentWeek].isCompleted = true
            currentWeek += 1
            currentProgress = 0
        } else {
            completedWeeks[currentWeek].progress += 1
            currentProgress = completedWeeks[currentWeek].progress
        }
    }
    
    enum AlertType {
        case logout
        case delete
        case none
    }
    
    struct CompletedSession: Codable {
        let date: Date
        let drills: [DrillData]
        var isCompleted: Bool = true
    }
    
    struct DrillData: Codable {
        let name: String
        let duration: Int
        let sets: Int
        let reps: Int
        let notes: String?
    }
    
    @Published var completedSessions: [CompletedSession] = []
    
    func completeSession(drills: [DrillData]) {
        let newSession = CompletedSession(
            date: Date(),
            drills: drills
        )
        completedSessions.append(newSession)
        
        // Save to UserDefaults or other persistence
        saveCompletedSessions()
    }
    
    func isDayCompleted(_ date: Date) -> Bool {
        completedSessions.contains { session in
            calendar.isDate(session.date, inSameDayAs: date)
        }
    }
    
    // Persistence
    private func saveCompletedSessions() {
        if let encoded = try? JSONEncoder().encode(completedSessions) {
            UserDefaults.standard.set(encoded, forKey: "completedSessions")
        }
    }
    
    private func loadCompletedSessions() {
        if let data = UserDefaults.standard.data(forKey: "completedSessions"),
           let decoded = try? JSONDecoder().decode([CompletedSession].self, from: data) {
            completedSessions = decoded
        }
    }
} 