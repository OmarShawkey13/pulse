# Pulse: The Rhythm of Your Device 🎵

**Pulse** is not just another music player; it's a meticulously crafted audio experience designed for those who value both aesthetic elegance and technical precision. Built with **Flutter**, Pulse brings your offline music library to life with a focus on fluid motion, adaptive design, and an unbreakable playback foundation.

---

## 🌟 The Pulse Experience

### 🎨 Adaptive Immersion
Music is visual as much as it is auditory. Pulse features a dynamic theme engine that breathes with your music. Using a custom `PaletteService`, the app UI intelligently extracts dominant hues from your album art, transforming the entire interface to match the mood of the track you’re currently spinning.

### 📜 Seamless Typography
We believe details matter. For those long, poetic song titles that usually get cut off, we built a custom **Marquee Engine**. It ensures every word is visible through smooth, hardware-accelerated scrolling, handling layout overflows with grace and precision.

### 🚀 Performance-First Playback
At the core of Pulse lies a high-performance engine powered by `just_audio` and `audio_service`. 
- **Uninterrupted Flow**: Experience rock-solid background playback that stays alive even when the system tries to be aggressive with battery saving.
- **Intuitive Control**: A gesture-based Mini Player allows you to navigate your library without ever losing track of what's playing.

### 🗂 Organized & Personal
Your music, your way. With dedicated sections for your **Favorites** and **Recently Played** tracks—all backed by a persistent **Sqflite** database—Pulse remembers what you love, so you don't have to.

---

## 🛠 Engineering & Architecture

Pulse is built on the principles of **Clean Architecture** and the **BLoC** pattern. This isn't just about code organization; it's about creating a scalable, testable, and maintainable product.

| Pillar                   | Technology                         | Purpose                                                             |
|:-------------------------|:-----------------------------------|:--------------------------------------------------------------------|
| **State Management**     | `flutter_bloc`                     | Predictable state transitions and separation of concerns.           |
| **Audio Core**           | `just_audio` & `audio_service`     | Low-latency playback and system-level audio integration.            |
| **Storage**              | `sqflite` & `shared_preferences`   | Reliable local data persistence and user preference caching.        |
| **Dependency Injection** | `get_it`                           | Decoupled components for better modularity.                         |
| **Polished UI**          | `skeletonizer` & Custom Animations | Providing a "shimmering" loading experience and smooth transitions. |

---

## 📂 Inside the Pulse

```text
lib/
├── core/                   # The Foundation
│   ├── di/                 # Dependency injection (Service Locator)
│   ├── network/            # Local DB (Sqflite) & Audio Handlers
│   ├── theme/              # Design System (Colors, Typography)
│   └── utils/              # Global Cubits & Custom UI Components
│
├── features/               # The Journey
│   ├── home/               # Library, Favorites, and Discovery
│   └── song_details/       # The immersive Full Player experience
│
└── main.dart               # App entry & initialization
```

---

## 🏁 Getting Started

### Prerequisites
- Flutter SDK (^3.11.1)
- Android device (API 21+)

### Quick Start
1. **Clone & Install**:
   ```bash
   git clone https://github.com/omarshawkey13/pulse.git
   cd pulse
   flutter pub get
   ```
2. **Permissions**: Ensure storage permissions are granted to let Pulse find your music.
3. **Run**:
   ```bash
   flutter run
   ```

---

## 📸 Preview

<p align="center">
  <img src="https://raw.githubusercontent.com/OmarShawkey13/pulse/main/screenshoot/app_screenshoot.png" alt="Pulse Showcase" width="90%" />
</p>

---
*Built with ❤️ and a passion for sound by **Omar Shawkey***
