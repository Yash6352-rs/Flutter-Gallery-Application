## 📱 Gallery Application

A modern Flutter Gallery Application built using MVVM architecture that displays images and videos in a clean and structured interface.

This project was developed to practice clean architecture, Riverpod state management, API integration using Dio, media handling, and persistent local storage in Flutter.

---

## 🚀 Project Overview

The application fetches images from:
https://jsonplaceholder.typicode.com/photos?_limit=20

Images are dynamically generated using:
https://picsum.photos

It also includes static video content to demonstrate video playback functionality.
- The app allows users to:
- View images and videos
- Like media (with persistence)
- Switch between Dark and Light themes (persistent)
- Browse categorized collections
- View detailed media previews
- Manage app settings

---

## 🏗️ Architecture

This project follows MVVM (Model-View-ViewModel) architecture with Riverpod for state management.

---

### 📂 Project Structure

### lib/
 ├── data/
 │   ├── models/
 │   │   └── media_model.dart
 │   ├── repository/
 │   │   └── media_repository.dart
 │
 ├── services/
 │   └── api_service.dart
 │
 ├── view_model/
 │   ├── media_provider.dart
 │   ├── liked_provider.dart
 │   └── theme_provider.dart
 │
 ├── views/
 │   ├── splash_screen.dart
 │   ├── main_screen.dart
 │   ├── home_screen.dart
 │   ├── collection_screen.dart
 │   ├── liked_screen.dart
 │   ├── detail_screen.dart
 │   ├── about_screen.dart
 │   ├── settings_screen.dart
 │   └── privacy_policy_screen.dart
 │
 ├── routes/
 │   └── app_router.dart
 │
 ├── utils/
 │   └── common_ui.dart
 │
 └── main.dart

---

## 🛠️ Tech Stack

- Flutter
- Dart
- Riverpod (StateNotifier + Provider)
- Dio (API calls)
- go_router (Navigation)
- SharedPreferences (Local persistence)
- Material 3 Design

---

## 📱 Features

- Splash Screen
- Fetch images from REST API using Dio
- Static video integration
- MVVM clean architecture
- State management using Riverpod
- Bottom Navigation with 3 tabs
- Folder-style collection screen
- Liked media with local persistence
- Persistent Dark/Light theme
- Video player with play/pause functionality
- Auto-hide play icon after 1 second
- Settings screen with feature placeholders
- About screen
- Privacy policy screen
- Loading and error handling
- Clean and responsive UI

---

## 🔄 App Flow

- Splash Screen appears
- Media is fetched from API
- Main screen loads with Bottom Navigation:
- Photos
- Collection
- Favourite

---

### Users can:
- View media in grid layout
- Tap media to open detail screen
- Like/unlike media
- Toggle theme from AppBar menu
- Liked items and theme preference persist even after app restart

---

### 📸 Screenshots

## 1. Splash Screen

- Displays app branding with a clean modern UI.
- Prepares navigation to the main screen.

## 2. Home Screen (Photos & Videos)

- Displays API images and static videos in a grid layout.
- Clean card-based media presentation.

## 3. Detail Screen

- Full media preview.
- Video playback with play/pause.
- Play icon auto disappears after 1 second.

## 4. Liked Screen

- Displays liked media only.
- Stored locally using SharedPreferences.
- Data persists after restart.

## 5. Collection Screen

### - Folder-style layout.
Categories:
- Images
- Videos
- Camera
- Screenshots
- Downloads
- Others

## 6. Settings & About

### Settings options:
- Backup
- Notifications
- Preferences
- Sharing
- Privacy Policy
- About screen shows:
- Version 1.0.0
- Developer information
- Privacy policy explains data handling.

---

## 🎨 Theme Support

- Light Theme
- Dark Theme
- Persistent theme mode using Riverpod
- Automatically restored on app restart

---

## 📦 Installation

### 1. Clone the repository:
- git clone https://github.com/your-username/gallery_application.git

### 2. Navigate to the project directory:
- cd gallery_application

### 3. Install dependencies:
- flutter pub get

### 4. Run the application:
- flutter run

---

## 📚 Key Learnings

- Implementing MVVM in Flutter
- Managing global state with Riverpod
- Persisting app state using SharedPreferences
- Building a media gallery UI
- Handling video playback in Flutter
- Dark/Light theme persistence
- Clean routing using go_router
- Structuring scalable Flutter applications

---

## 👨‍💻 Developer

Develop as a part of my internship
Built with Flutter 💙
