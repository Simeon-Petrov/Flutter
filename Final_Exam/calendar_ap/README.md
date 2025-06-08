# Calendar App

This is a simple calendar application built with Flutter and Firebase.

## Features:
- User authentication (login, registration, guest access)
- Calendar view with event markers
- Create, edit, and delete events
- Slide Transition Widget after Login, Edit event and Add new event
- Event notifications - 20 minutes before event
- Add event color labels

## Setup Instructions

Follow these steps to get the project up and running on your local machine.

### Prerequisites

* **Flutter SDK:** Make sure you have Flutter installed. You can download it from [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install).
* **Firebase Project:** You will need a Firebase project set up.
    * Create a new project in the [Firebase Console](https://console.firebase.google.com/).
    * Add a Flutter app to your Firebase project, following the instructions [here](https://firebase.google.com/docs/flutter/setup).
    * Download `google-services.json` for Android and `GoogleService-Info.plist` for iOS and place them in the correct directories (`android/app/` and `ios/Runner/` respectively).
    * Enable **Firestore Database** and **Authentication** (Email/Password and Anonymous) in your Firebase project.

### Installation

1.  **Clone the repository:**
    ```bash
    git clone [<your_repository_url>](https://github.com/Simeon-Petrov/Flutter/tree/main/Final_Exam/calendar_ap)
    cd calendar_ap
    ```

2.  **Install Flutter dependencies:**
    ```bash
    flutter pub get
    ```

### Running the Application

1.  **Ensure you have a device connected or an emulator/simulator running:**
    ```bash
    flutter devices
    ```

2.  **Run the app:**
    ```bash
    flutter run
    ```
    This will build and launch the application on your connected device or emulator.

## Project Structure

- `lib/main.dart`: Main entry point of the application.
- `lib/screens/`: Contains all the different screens of the app (login, home, event form, etc.).
- `lib/models/`: Data models for events.
- `lib/services/`: Firebase interaction, notification service, etc.
- `pubspec.yaml`: Project dependencies.

---
