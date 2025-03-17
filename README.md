# BravoBall Frontend

## Overview
BravoBall is a personalized soccer training app that creates custom training sessions based on user preferences and skill levels. The app helps players improve their skills through tailored drills and progress tracking.

## Features

- **Personalized Training**: Custom training sessions based on user's skill level, goals, and available equipment
- **Skill-Focused Drills**: Targeted drills for specific skills like passing, shooting, dribbling, and more
- **Progress Tracking**: Track completed sessions and monitor improvement over time
- **Drill Library**: Save favorite drills and create custom drill collections
- **Filter System**: Find drills based on equipment, difficulty, duration, and more
- **Offline Support**: Cache system for using the app without constant internet connection
- **Test Mode**: Development feature to quickly test app functionality

## Installation

### Prerequisites
- Xcode 14.0+
- iOS 16.0+
- Swift 5.7+
- CocoaPods or Swift Package Manager

### Setup
1. Clone the repository:
   ```bash
   git clone https://github.com/jordanconklin/BravoBall_Frontend.git
   cd BravoBall_Frontend
   ```

2. Install dependencies:
   ```bash
   pod install
   ```
   or if using Swift Package Manager:
   ```bash
   swift package resolve
   ```

3. Open the project:
   ```bash
   open BravoBall.xcworkspace
   ```

4. Build and run the project in Xcode

## Architecture

BravoBall follows the MVVM (Model-View-ViewModel) architecture pattern:

- **Models**: Data structures representing the core domain objects
- **Views**: SwiftUI views for the user interface
- **ViewModels**: Business logic and state management
- **Services**: API communication and data processing

### Key Components

- **OnboardingModel**: Manages the user onboarding process
- **SessionGeneratorModel**: Handles session creation and management
- **UserManager**: User authentication and profile management
- **CacheManager**: Local data persistence
- **DataSyncService**: Synchronization with the backend

### Model Relationships

The app has several interconnected data models with the following key relationships:

- Users have onboarding data, multiple sessions, saved drill groups, and filter preferences
- Sessions contain multiple drills with progress tracking
- Drill groups organize collections of drills that users can save and favorite

For a detailed diagram and explanation of all model relationships, see the [Schema Guide](SCHEMA.md#model-relationships).

## Development Workflow

### Branch Strategy
- `main`: Production-ready code
- `develop`: Integration branch for features
- `feature/*`: Individual feature branches

### Merging Process
Use the provided `merge-feature.sh` script to streamline the process of merging feature branches:

```bash
./merge-feature.sh
```

This script will:
1. Commit and push your current branch
2. Merge to develop (if desired)
3. Merge to main (if desired)
4. Handle conflicts appropriately

## Data Schema

For detailed information about the app's data structures, models, and API interactions, please refer to the [Schema Guide](SCHEMA.md).

## Testing

### Unit Tests
Run unit tests in Xcode using the test navigator or via command line:
```bash
xcodebuild test -workspace BravoBall.xcworkspace -scheme BravoBall -destination 'platform=iOS Simulator,name=iPhone 14'
```

### UI Tests
UI tests can be run through Xcode's test navigator.

### Test Mode
Enable test mode by setting `skipOnboarding = true` in the OnboardingModel to bypass the onboarding process with pre-filled test data.

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.