**NAME**:MUSHEIJA ABRAHAM



**STUDENT NO**:2300712139



**REG NO**:23/U/12139/EVE

**Flutter Task Notes Manager**
Project Overview

The **Task Notes Manager** is a lightweight Flutter application built to help users organize their daily tasks and notes with ease.
It offers a simple yet efficient interface that allows users to create, view, update, and delete tasks while keeping data stored locally using the **SQFLite** database.

The app includes a built-in theme toggle that lets users switch between light and dark modes. All preferences are saved locally, providing a consistent user experience each time the app is launched.

---

Key Features

* Create, edit, and delete tasks or notes
* Persistent local storage using **SQFLite**
* **Light and dark theme** support with saved preferences
* Smooth and intuitive navigation between screens
* Offline-first design — no internet connection required
* Simple, clean, and responsive user interface

---

Technologies Used

| Component     | Technology                                        |
| ------------- | ------------------------------------------------- |
| Framework     | Flutter (Dart)                                    |
| Database      | SQFLite                                           |
| Local Storage | SharedPreferences                                 |
| Architecture  | MVC-inspired structure (Screens, Models, Helpers) |
| UI Design     | Material Design principles                        |

---

Project Structure

```
lib/
├── main.dart                 // App entry point and theme configuration
├── theme.dart                // Light and dark theme setup
├── models/
│   └── task_item.dart        // Task model class with JSON serialization
├── database/
│   └── database_helper.dart  // SQFLite database handler (CRUD operations)
└── screens/
    ├── home_screen.dart      // Main screen displaying all saved tasks
    └── add_task_screen.dart  // Screen for adding new tasks
```

---

Getting Started

Follow the steps below to set up and run the project locally.

1. Clone the Repository

```bash
git clone https://github.com/Musheijaa/flutter-task-notes-app.git
cd flutter-task-notes-app
```
2. Install Dependencies

```bash
flutter pub get
```

3. Run the Application

Ensure you have an emulator or physical device connected, then run:

```bash
flutter run
```

4. Build for Release (Optional)

To create a release APK:

```bash
flutter build apk --release
```

The release build will be available at:

```
build/app/outputs/flutter-apk/app-release.apk
```

---

How It Works

* When the app starts, it initializes the **SQFLite** database to store tasks locally.
* Users can add new tasks through the **Add Task** screen.
* Tasks are displayed on the **Home Screen** with options to edit or delete.
* The selected theme mode (light or dark) is stored using **SharedPreferences**, ensuring it persists after closing the app.

---


Author

**Developed by:** Musheija Abraham
**GitHub:** [https://github.com/Musheijaa](https://github.com/Musheijaa)
