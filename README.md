# BravoBall Frontend

## Overview
BravoBall is a personalized soccer training app that creates custom training sessions based on user preferences and skill levels. This document outlines the key data structures and API interactions used in the app.

## Data Schemas

### User Data

#### OnboardingData
```swift
struct OnboardingData {
    var primaryGoal: String
    var biggestChallenge: String
    var trainingExperience: String
    var position: String
    var playstyle: String
    var ageRange: String
    var strengths: [String]
    var areasToImprove: [String]
    var trainingLocation: [String]
    var availableEquipment: [String]
    var dailyTrainingTime: String
    var weeklyTrainingDays: String
    var firstName: String
    var lastName: String
    var email: String
    var password: String
}
```

### Session Data

#### SessionResponse
Response from the backend after onboarding or requesting a new session:
```swift
struct SessionResponse: Decodable {
    let sessionId: Int
    let totalDuration: Int
    let focusAreas: [String]
    let drills: [DrillResponse]
}
```

#### DrillResponse
Drill data received from the backend:
```swift
struct DrillResponse: Decodable {
    let id: Int
    let title: String
    let description: String
    let duration: Int
    let intensity: String
    let difficulty: String
    let equipment: [String]
    let suitableLocations: [String]
    let instructions: [String]
    let tips: [String]
    let type: String
    let sets: Int?
    let reps: Int?
    let rest: Int?
}
```

#### DrillModel
Internal model used for representing drills in the app:
```swift
struct DrillModel: Identifiable, Equatable, Codable {
    let id: UUID
    let title: String
    let skill: String
    let sets: Int
    let reps: Int
    let duration: Int
    let description: String
    let tips: [String]
    let equipment: [String]
    let trainingStyle: String
    let difficulty: String
}
```

#### EditableDrillModel
Used for tracking drill progress during a session:
```swift
struct EditableDrillModel: Identifiable, Equatable, Codable {
    let id: UUID
    let drill: DrillModel
    var setsDone: Int
    let totalSets: Int
    let totalReps: Int
    let totalDuration: Int
    var isCompleted: Bool
}
```

### Saved Data

#### GroupModel
Used for organizing saved drills:
```swift
struct GroupModel: Identifiable, Codable {
    let id: UUID
    var name: String
    var description: String
    var drills: [DrillModel]
}
```

#### SavedFiltersModel
Used for saving filter preferences:
```swift
struct SavedFiltersModel: Identifiable, Codable {
    let id: UUID
    var name: String
    var savedTime: String?
    var savedEquipment: Set<String>
    var savedTrainingStyle: String?
    var savedLocation: String?
    var savedDifficulty: String?
}
```

## API Interactions

### Authentication

#### Login
```
POST /api/auth/login
Body: { "email": String, "password": String }
Response: { "access_token": String, "token_type": String, "user_id": Int }
```

#### Register (via Onboarding)
```
POST /api/onboarding/complete
Body: OnboardingData mapped to backend format
Response: { 
  "status": String,
  "message": String,
  "access_token": String,
  "token_type": String,
  "user_id": Int,
  "initial_session": SessionResponse
}
```

### Sessions

#### Get Initial Session
Automatically returned after onboarding completion.

#### Get New Session
```
GET /api/sessions/generate
Headers: Authorization: Bearer {token}
Query Parameters: Optional filters
Response: SessionResponse
```

#### Complete Session
```
POST /api/sessions/complete
Headers: Authorization: Bearer {token}
Body: { 
  "session_id": Int,
  "completed_drills": Int,
  "total_drills": Int,
  "date": String (ISO format)
}
Response: { "status": String, "message": String }
```

## Data Mapping

### Backend to Frontend Skill Mapping
```swift
let skillMap = [
    "passing": "Passing",
    "dribbling": "Dribbling",
    "shooting": "Shooting",
    "defending": "Defending",
    "first_touch": "First touch",
    "fitness": "Fitness"
]
```

### Frontend to Backend Equipment Mapping
```swift
let equipmentMap = [
    "Soccer ball": "ball",
    "Cones": "cones",
    "Goal": "goal",
    "Wall": "wall",
    "Agility ladder": "ladder",
    "Resistance bands": "bands"
]
```

## Caching

The app uses a CacheManager to store:
- Ordered drills for the current session
- Saved drill groups
- Liked drills
- Filter preferences
- Completed sessions history

Cache keys are user-specific, based on the user's email.

## Test Mode

The app includes a test mode that can be enabled by toggling `skipOnboarding` in the OnboardingModel. This allows bypassing the onboarding process with pre-filled test data for faster development and testing.