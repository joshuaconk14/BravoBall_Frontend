# BravoBall Schema Guide

This document provides a comprehensive overview of all data structures, models, and API interactions used in the BravoBall app.

## Table of Contents
- [Model Relationships](#model-relationships)
- [User Data Models](#user-data-models)
- [Session Data Models](#session-data-models)
- [Drill Data Models](#drill-data-models)
- [Saved Data Models](#saved-data-models)
- [API Interactions](#api-interactions)
- [Data Mapping](#data-mapping)
- [Caching](#caching)

## Model Relationships

The BravoBall app has several interconnected data models. Here's how they relate to each other:

```
User
 │
 ├─── OnboardingData (1:1) ─── User preferences for training
 │
 ├─── Sessions (1:N)
 │     │
 │     └─── Drills (1:N) ─── Each session contains multiple drills
 │
 ├─── Saved Drill Groups (1:N)
 │     │
 │     └─── Drills (1:N) ─── User can organize drills into custom groups
 │
 ├─── Liked Drills (1:1)
 │     │
 │     └─── Drills (0:N) ─── User can mark drills as favorites
 │
 └─── Saved Filters (1:N) ─── User can save filter preferences
```

### Key Relationships

1. **User → OnboardingData**: Each user completes the onboarding process once, which collects their preferences, goals, and training setup.

2. **User → Sessions**: 
   - A user can have multiple training sessions
   - Each session belongs to one user
   - Sessions contain multiple drills selected based on user preferences
   - Completed sessions are tracked for progress monitoring

3. **User → Drill Groups**:
   - Users can create multiple custom drill groups (collections)
   - Each group belongs to one user
   - Groups contain multiple drills that the user has saved
   - The "Liked Drills" group is a special case that contains favorited drills

4. **User → Saved Filters**:
   - Users can save multiple filter configurations
   - Each saved filter belongs to one user
   - Filters contain preferences for equipment, difficulty, duration, etc.

5. **Session → Drills**:
   - Each session contains multiple drills
   - Drills in a session are tracked with the EditableDrillModel which adds progress tracking
   - The same drill can appear in multiple sessions

6. **Group → Drills**:
   - Each group contains multiple drills
   - The same drill can appear in multiple groups
   - Drills in groups are stored as DrillModel instances

### Data Flow

1. **Onboarding → Initial Session**:
   - User completes onboarding
   - Backend generates initial session based on preferences
   - Session is loaded with appropriate drills

2. **Session Generation**:
   - User can generate new sessions with filters
   - Filters can be saved for future use
   - Generated sessions contain drills matching the filters

3. **Drill Management**:
   - User can save drills to groups
   - User can like/favorite drills
   - User can create custom collections of drills

4. **Progress Tracking**:
   - Completed sessions are saved
   - Streak and total session count are tracked
   - User progress is synced with the backend

## User Data Models

### OnboardingData
Data collected during the user onboarding process.

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

### UserProfile
User profile information stored after registration.

```swift
struct UserProfile: Codable {
    let userId: Int
    let email: String
    let firstName: String
    let lastName: String
    let createdAt: Date
    let lastLogin: Date?
}
```

## Session Data Models

### SessionResponse
Response from the backend after onboarding or requesting a new session.

```swift
struct SessionResponse: Decodable {
    let sessionId: Int
    let totalDuration: Int
    let focusAreas: [String]
    let drills: [DrillResponse]
}
```

### CompletedSession
Represents a completed training session.

```swift
struct CompletedSession: Codable, Identifiable {
    let id: UUID
    let date: Date
    let completedDrills: Int
    let totalDrills: Int
    let duration: Int
}
```

## Drill Data Models

### DrillResponse
Drill data received from the backend.

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
    
    enum CodingKeys: String, CodingKey {
        case id, title, description, duration, intensity, difficulty
        case equipment
        case suitableLocations = "suitable_locations"
        case instructions
        case tips
        case type
        case sets
        case reps
        case rest
    }
    
    func toDrillModel() -> DrillModel {
        return DrillModel(
            id: UUID(),
            title: title,
            skill: type,
            sets: sets ?? 0,
            reps: reps ?? 0,
            duration: duration,
            description: description,
            tips: tips,
            equipment: equipment,
            trainingStyle: intensity,
            difficulty: difficulty
        )
    }
}
```

### DrillModel
Internal model used for representing drills in the app.

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

### EditableDrillModel
Used for tracking drill progress during a session.

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

## Saved Data Models

### GroupModel
Used for organizing saved drills.

```swift
struct GroupModel: Identifiable, Codable {
    let id: UUID
    var name: String
    var description: String
    var drills: [DrillModel]
}
```

### SavedFiltersModel
Used for saving filter preferences.

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

### User Data

#### Update User Profile
```
PUT /api/users/profile
Headers: Authorization: Bearer {token}
Body: { 
  "first_name": String,
  "last_name": String,
  "email": String
}
Response: { "status": String, "message": String }
```

#### Sync User Preferences
```
POST /api/users/preferences
Headers: Authorization: Bearer {token}
Body: { 
  "selected_time": String?,
  "selected_equipment": [String],
  "selected_training_style": String?,
  "selected_location": String?,
  "selected_difficulty": String?,
  "current_streak": Int,
  "highest_streak": Int,
  "completed_sessions_count": Int
}
Response: { "status": String, "message": String }
```

### Drill Groups

#### Get All Drill Groups
```
GET /api/drill-groups/
Headers: Authorization: Bearer {token}
Response: [DrillGroupResponse]
```

#### Get Drill Group by ID
```
GET /api/drill-groups/{group_id}
Headers: Authorization: Bearer {token}
Response: DrillGroupResponse
```

#### Create Drill Group
```
POST /api/drill-groups/
Headers: Authorization: Bearer {token}
Body: {
  "name": String,
  "description": String,
  "drills": [DrillResponse],
  "is_liked_group": Boolean
}
Response: DrillGroupResponse
```

#### Update Drill Group
```
PUT /api/drill-groups/{group_id}
Headers: Authorization: Bearer {token}
Body: {
  "name": String,
  "description": String,
  "drills": [DrillResponse],
  "is_liked_group": Boolean
}
Response: DrillGroupResponse
```

#### Delete Drill Group
```
DELETE /api/drill-groups/{group_id}
Headers: Authorization: Bearer {token}
Response: { "message": String }
```

#### Add Drill to Group
```
POST /api/drill-groups/{group_id}/drills/{drill_id}
Headers: Authorization: Bearer {token}
Response: { "message": String }
```

#### Remove Drill from Group
```
DELETE /api/drill-groups/{group_id}/drills/{drill_id}
Headers: Authorization: Bearer {token}
Response: { "message": String }
```

#### Get/Create Liked Drills Group
```
GET /api/liked-drills
Headers: Authorization: Bearer {token}
Response: DrillGroupResponse
```

#### Toggle Drill Like Status
```
POST /api/drills/{drill_id}/like
Headers: Authorization: Bearer {token}
Response: { "message": String, "is_liked": Boolean }
```

#### Check if Drill is Liked
```
GET /api/drills/{drill_id}/like
Headers: Authorization: Bearer {token}
Response: { "is_liked": Boolean }
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
    "fitness": "Fitness",
    "set_based": "Set-based",
    "reps_based": "Reps-based"
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

### Frontend to Backend Training Experience Mapping
```swift
let experienceMap = [
    "Beginner": "beginner",
    "Intermediate": "intermediate",
    "Advanced": "advanced"
]
```

### Frontend to Backend Age Range Mapping
```swift
let ageRangeMap = [
    "Youth (8-12)": "youth",
    "Teen (13-16)": "teen",
    "Young Adult (17-21)": "young_adult",
    "Adult (22+)": "adult"
]
```

## Caching

The app uses a CacheManager to store user-specific data locally.

### Cache Keys
```swift
enum CacheKey {
    case orderedDrillsCase
    case savedDrillsCase
    case likedDrillsCase
    case filterGroupsCase
    case completedSessionsCase
    case currentStreakCase
    case highestStreakCase
    case countOfCompletedSessionsCase
    
    func forUser(_ email: String) -> String {
        return "\(email)_\(self.rawValue)"
    }
}
```

### Cached Data Types
- **orderedDrills**: `[EditableDrillModel]` - Drills for the current session
- **savedDrills**: `[GroupModel]` - User-saved drill groups
- **likedDrills**: `GroupModel` - User's liked drills
- **filterGroups**: `[SavedFiltersModel]` - User's saved filter preferences
- **completedSessions**: `[CompletedSession]` - History of completed sessions
- **currentStreak**: `Int` - User's current training streak
- **highestStreak**: `Int` - User's highest training streak
- **countOfCompletedSessions**: `Int` - Total number of completed sessions 