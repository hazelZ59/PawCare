# PawCare - Cat Health Tracking App

## Project Summary

PawCare is an iOS app built with SwiftUI that helps cat owners track their cats' health records, including vaccinations, medications, vet visits, and weight history.

## Development Process

1. **Prototype Design**: Started with HTML/CSS prototypes to define the UI/UX
2. **SwiftUI Implementation**: Converted the prototype designs into functional SwiftUI code
3. **Data Models**: Created models for User, Cat, HealthRecord, and WeightRecord
4. **Services**: Implemented AuthService for authentication and DataService for data management
5. **Views**: Created multiple views for different app features
6. **Components**: Extracted reusable UI components

## App Features

- **Authentication**: Login/Register with email and password
- **Home Dashboard**: Overview of cats and recent activities
- **Health Records**: Track medical history with file attachments
- **Weight Tracking**: Monitor weight changes with charts
- **Cat Profiles**: Manage cat information with breed selection
- **Settings**: User preferences and app configuration

## Project Structure

```
PawCare/
├── Models/
│   ├── Cat.swift
│   ├── HealthRecord.swift
│   ├── User.swift
│   └── WeightRecord.swift
├── Services/
│   ├── AuthService.swift
│   └── DataService.swift
├── Views/
│   ├── Authentication/
│   │   └── LoginView.swift
│   ├── Components/
│   │   └── UIComponents.swift
│   ├── Health/
│   │   └── HealthRecordsView.swift
│   ├── Home/
│   │   └── HomeView.swift
│   ├── Profile/
│   │   └── CatProfileView.swift
│   ├── Settings/
│   │   └── SettingsView.swift
│   ├── Weight/
│   │   └── WeightTrackingView.swift
│   └── MainTabView.swift
└── PawCareApp.swift
```

## Development Challenges and Solutions

1. **Challenge**: Missing UI components in HomeView.swift
   **Solution**: Created a separate UIComponents.swift file to centralize reusable views

2. **Challenge**: LazyVGrid errors with conditional rendering
   **Solution**: Refactored to use computed properties instead of inline conditionals

3. **Challenge**: Organizing the app structure
   **Solution**: Used MVVM pattern with separate models, views, and services

## Next Steps

1. Implement add cat functionality
2. Implement add health record functionality
3. Implement add weight record functionality
4. Add data persistence with Core Data or Firebase
5. Implement cloud synchronization
6. Add notifications for medication and vet visit reminders

## GitHub Repository

The project is hosted on GitHub at: https://github.com/hazelZ59/PawCare

## Credits

- Developed based on HTML/CSS prototype designs
- Uses SwiftUI and Swift Charts for UI components
- FontAwesome icons used in the prototype design
