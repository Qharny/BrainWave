# BrainWave Quiz App

## Overview
BrainWave is a Flutter-based quiz application designed to provide users with an engaging and interactive way to test their knowledge across various subjects. The app features user authentication, profile management, quiz history, and customizable settings.

## Features
- **User Authentication**: Users can register and log in to their accounts.
- **Profile Management**: Users can view and edit their profiles, including their name and email.
- **Quiz Categories**: Users can select from various quiz categories such as Science, History, Mathematics, and Geography.
- **Dynamic Quizzes**: Users can take quizzes with questions fetched from an API.
- **Quiz History**: Users can view their quiz history and scores.
- **Settings**: Users can customize their app experience, including theme and text size.

## Technologies Used
- **Flutter**: The framework used for building the app.
- **Hive**: A lightweight and fast key-value database for storing user data locally.
- **Flutter Animate**: A package for adding animations to the UI components.

## Project Structure

```
lib/
├── auth/
│   └── auth.dart          # Authentication screen and logic
├── screen/
│   ├── dashboard.dart     # Main dashboard with quiz categories
│   ├── edit_profile.dart   # Dialog for editing user profile
│   ├── home.dart          # Quiz screen for taking quizzes
│   ├── profile.dart       # User profile screen
│   ├── quiz_history.dart   # Screen to view quiz history
│   └── settings.dart      # Settings screen for app customization
├── main.dart              # Entry point of the application
└── splash.dart            # Splash screen displayed on app launch
```

## Getting Started

### Prerequisites
- Flutter SDK installed on your machine.
- An IDE such as Android Studio or Visual Studio Code.

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/qharny/brainwave.git
   cd brainwave-quiz-app
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

### Usage
- Upon launching the app, users will see a splash screen followed by the authentication screen.
- Users can register or log in to access the main dashboard.
- From the dashboard, users can select a quiz category to start taking quizzes.
- Users can navigate to their profile to view and edit their information, as well as access their quiz history.

## Contributing
Contributions are welcome! Please open an issue or submit a pull request for any enhancements or bug fixes.

## License
This project is licensed under the MIT License. See the LICENSE file for details.

## Acknowledgments
- Thanks to the Flutter community for their support and resources.
- Special thanks to the contributors of the packages used in this project.
