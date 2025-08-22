# PawCare - Cat Health Tracking App

PawCare is an iOS application built with SwiftUI that helps cat owners track their cats' health records, including vaccinations, medications, vet visits, and weight history.

## Features

- **Multiple Cat Profiles**: Manage health records for multiple cats
- **Health Records**: Track vaccinations, medications, vet visits, and symptoms
- **File Attachments**: Attach images and documents to health records
- **Weight Tracking**: Monitor weight changes over time with visual charts
- **Reminders**: Get notified about upcoming vaccinations and medications
- **User Authentication**: Secure login and registration

## Screenshots

*Screenshots will be added soon*

## Requirements

- iOS 16.0+
- Xcode 14.0+
- Swift 5.7+

## Installation

1. Clone the repository:
```bash
git clone https://github.com/hazelZ59/PawCare.git
```

2. Open the project in Xcode:
```bash
cd PawCare
open PawCare.xcodeproj
```

3. Build and run the app on your device or simulator.

## Architecture

PawCare follows the MVVM (Model-View-ViewModel) architecture pattern:

- **Models**: Data structures for User, Cat, HealthRecord, and WeightRecord
- **Views**: SwiftUI views for different screens and components
- **Services**: Business logic for authentication and data management

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
│   ├── Components/
│   ├── Health/
│   ├── Home/
│   ├── Profile/
│   ├── Settings/
│   └── Weight/
└── PawCareApp.swift
```

## Future Enhancements

- Cloud synchronization with iCloud
- Medication scheduling and tracking
- Diet tracking and recommendations
- Integration with veterinary services
- Health analytics and insights
- Dark mode support

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgements

- Design inspired by modern iOS applications
- Icons from SF Symbols and FontAwesome
- Demo images from Unsplash
