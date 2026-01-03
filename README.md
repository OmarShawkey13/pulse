# Pulse Music Player 🎵

**Pulse** is a modern, feature-rich offline music player application built with **Flutter**. It provides a seamless audio listening experience with background playback support, notification controls, and a beautiful, intuitive user interface.

## 🚀 Features

- **Local Music Scanning**: Automatically fetches all audio files from your device storage using `on_audio_query_pluse`.
- **Background Playback**: Continue listening to music even when the app is closed or the screen is off, powered by `audio_service`.
- **Media Notification**: Control playback (Play, Pause, Next, Previous) directly from the notification center and lock screen.
- **State Management**: Robust state management using the **BLoC (Business Logic Component)** pattern.
- **Theme Support**: Toggle between **Light** and **Dark** modes with preference persistence.
- **Playback Persistence**: Remembers your last played song and playback position, so you can pick up right where you left off.
- **Beautiful UI Animations**: Enjoy smooth visual experiences with animated wave backgrounds and skeletal loading effects.
- **Clean Architecture**: Built with scalability and maintainability in mind, separating presentation, domain, and data layers.

## 🛠 Tech Stack & Packages

This project relies on a robust set of Flutter packages to deliver its functionality:

| Package                                                                         | Usage                                                                                                     |
|---------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------|
| **[flutter_bloc](https://pub.dev/packages/flutter_bloc)**                       | Used for predictable state management, separating business logic from UI.                                 |
| **[just_audio](https://pub.dev/packages/just_audio)**                           | The core audio engine for playing music, seeking, and handling player states.                             |
| **[audio_service](https://pub.dev/packages/audio_service)**                     | Wraps `just_audio` to provide background execution, media notifications, and headset button integration.  |
| **[on_audio_query_pluse](https://pub.dev/packages/on_audio_query_pluse)**       | Efficient fetching of audio files, albums, and artists from the device's storage.                         |
| **[get_it](https://pub.dev/packages/get_it)**                                   | A service locator for Dependency Injection (DI), managing singletons like `AudioHandler` and `HomeCubit`. |
| **[shared_preferences](https://pub.dev/packages/shared_preferences)**           | Persists simple data locally, such as the selected theme (Dark/Light) and the last played song details.   |
| **[skeletonizer](https://pub.dev/packages/skeletonizer)**                       | Provides loading skeleton animations for a smoother user experience while fetching songs.                 |
| **[flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons)**   | Automates the generation of launcher icons for Android and iOS.                                           |
| **[flutter_native_splash](https://pub.dev/packages/flutter_native_splash)**     | Automatically generates native splash screens with support for dark mode.                                 |

## 📂 Project Architecture

The project follows a **Feature-First** structure combined with Clean Architecture principles:

```
lib/
├── core/                   # Core functionality shared across the app
│   ├── di/                 # Dependency Injection setup (GetIt)
│   ├── models/             # Data models (e.g., SongModel)
│   ├── network/            # Network/Local data services
│   │   ├── local/          # CacheHelper (SharedPreferences)
│   │   └── service/        # PulseAudioHandler (AudioService setup)
│   ├── theme/              # App themes (Light/Dark configurations)
│   └── utils/              # Utilities, Constants, Cubits (HomeCubit)
│
├── features/               # Application features
│   ├── home/               # Home screen (Song list)
│   │   └── presentation/   # UI: Screens and Widgets
│   └── song_details/       # Song Player screen
│       └── presentation/   # UI: Screens and Widgets
│
└── main.dart               # Entry point, App initialization
```

### Key Components

1.  **PulseAudioHandler (`lib/core/network/service/`)**:
    - Extends `BaseAudioHandler` from `audio_service`.
    - Manages the `just_audio` player instance.
    - Maps player events (play, pause, seek) to system notifications.
    - Handles audio focus and external controls (headsets, Bluetooth).

2.  **HomeCubit (`lib/core/utils/cubit/`)**:
    - Manages the application state (Loading, Success, Error, Player States).
    - Interfaces between the UI and the `PulseAudioHandler`.
    - Handles song querying and queue management.

3.  **CacheHelper (`lib/core/network/local/`)**:
    - A wrapper around `SharedPreferences` to easily save and retrieve user preferences and player state.

## 🏁 Getting Started

### Prerequisites
- Flutter SDK (version ^3.10.4 or higher)
- Android Studio / VS Code
- An Android device or emulator

### Installation

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/omarshawkey13/pulse.git
    cd pulse
    ```

2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Generate Assets (Icons & Splash)**:
    Since this project uses `flutter_launcher_icons` and `flutter_native_splash`, you might want to run:
    ```bash
    dart run flutter_launcher_icons
    dart run flutter_native_splash:create
    ```

4.  **Run the app**:
    ```bash
    flutter run
    ```

### Android Permissions
The app requires permission to read external storage to find music files.
Ensure your `AndroidManifest.xml` includes:
```xml
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.READ_MEDIA_AUDIO"/> <!-- For Android 13+ -->
```
*Note: The app handles runtime permission requests on first launch.*

## 📸 Screenshots

<p align="center">
  <img src="https://raw.githubusercontent.com/OmarShawkey13/pulse/main/screenshoot/app_screenshoot.png"
       alt="Pulse Music App Showcase"
       width="90%" />
</p>

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.
