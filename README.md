# Roommate Matching App

## Overview
This repository contains the source code for the Roommate Matching mobile application, developed using Flutter and Firebase. The app aims to connect individuals looking for roommates by matching profiles based on shared preferences and habits.

## Structure
- `lib/main.dart`: The entry point of the application, initializing the Firebase app and running the main app widget.
- `lib/main/main_page.dart`: Hosts the primary navigation and tab views.
- `lib/UI/`: Contains the user interface elements and screens for the app, including swappable cards, surveys, and user profiles.
- `lib/UI/chat.dart`: Implements the chat interface and functionality.
- `lib/UI/matches.dart`: Contains the logic for matching user profiles.

## Firebase Integration
- `cloud_firestore`: Used for storing and retrieving user data and preferences.
- `firebase_auth`: Manages user authentication processes.
- `firebase_database`: Real-time database interactions for chat and user data handling.
- `firebase_storage`: Handles the uploading and storage of user profile images.

## Setup
To run this project, ensure you have Flutter installed on your machine and a Firebase project set up with the necessary configurations.

1. Clone the repository to your local machine.
2. Navigate to the project directory and run `flutter pub get` to install dependencies.
3. Open an emulator or connect a physical device.
4. Execute `flutter run` to build and run the app on your device.

## Testing
Tests can be found in the `test/` directory. Run tests using the `flutter test` command to ensure code quality and functionality.

## Contribution
Please read `CONTRIBUTING.md` for details on our code of conduct, and the process for submitting pull requests to us.

---

This README is a brief overview of the app's structure and setup instructions. For more detailed information, please refer to the individual `.dart` files within the `lib/` directory.

## Getting Started

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the [online documentation](https://docs.flutter.dev/), which offers tutorials, samples, guidance on mobile development, and a full API reference.
