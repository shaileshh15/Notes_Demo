# Secure Notes App

A Flutter application for secure note-taking with PIN authentication.

## Setup Instructions

1. Clone the repository:
```bash
git clone https://github.com/shaileshh15/Notes_Demo.git
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Assumptions & Decisions

1. PIN-based authentication for app security
2. Local storage using Hive database
3. State management with Provider
4. Responsive UI with Flutter ScreenUtil
5. Secure storage for sensitive data

## Dependencies

- `flutter_screenutil`: ^5.9.3 (Responsive design)
- `flutter_secure_storage`: ^9.2.4 (Secure data storage)
- `hive`: ^2.2.3 (Local database)
- `hive_flutter`: ^1.1.0 (Hive integration)
- `local_auth`: ^2.3.0 (Biometric authentication)
- `path_provider`: ^2.1.5 (File system access)
- `provider`: ^6.1.5 (State management)
