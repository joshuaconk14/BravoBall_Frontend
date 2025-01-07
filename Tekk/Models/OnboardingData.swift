extension OnboardingData {
    // Add a function to convert age range string to an integer
    private func ageRangeToInt(_ ageRange: String) -> Int {
        switch ageRange {
            case "Youth (8-12)": return 10
            case "Teen (13-16)": return 15
            case "Young Adult (17-19)": return 18
            case "Adult (20-29)": return 25
            case "Adult (30+)": return 30
            default: return 20 // default age if unknown
        }
    }
    
    // Modify the data before sending to backend
    func toBackendFormat() -> [String: Any] {
        return [
            "email": email,
            "first_name": firstName,
            "last_name": lastName,
            "password": password,
            "age": ageRangeToInt(ageRange),  // Convert string to int
            "level": level,
            "position": position,
            "playstyle_representatives": playstyleRepresentatives,
            "strengths": strengths,
            "weaknesses": weaknesses,
            "has_team": hasTeam,
            "primary_goal": primaryGoal,
            "timeline": timeline,
            "skill_level": skillLevel,
            "training_days": trainingDays,
            "available_equipment": availableEquipment
        ]
    }
} 