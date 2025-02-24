# Grab Hot Deal Game

## 📌 Overview

**Grab Hot Deal Game** is an interactive **restaurant promo selection game** designed for **Android TV (TR3DK Series)** running at **3840 x 2160 (portrait) with multi-touch support**. The game challenges players to select at least **5 restaurant promotions** with an **80% discount** before the **timer runs out**.

Players can **compete for high scores**, submit their names to the leaderboard via **Firebase**, and track rankings in real-time.

## 🚀 Features

- **Android TV-Optimized UI:** Tailored for **TR3DK Series** running at **3840 x 2160 (portrait)**.
- **Multi-Touch Support:** Allows players to interact efficiently.
- **Firebase Integration:** Stores player names and scores for the leaderboard.
- **Step-by-Step Game Flow:** From tutorial to leaderboard.
- **Progressive Gameplay:** Time-based challenge requiring quick decision-making.

## 📱 Screens & Flow

1. **Start Page:**
   - Displays the game title and allows players to begin.
2. **Tutorial Page:**
   - Explains the game rules: Select **at least 5 promos** with **80% off** before **time runs out**.
3. **Game Page:**
   - Players tap promo offers to make their selection.
   - **Countdown Timer:** Reduces time if incorrect promo is selected.
   - **Win Condition:** Select 5 correct promos before **50% of the time expires**.
   - **Lose Condition:** Failing to meet the win condition before time runs out.
4. **Win Screen:**
   - Player submits their **name & score**.
   - Data is stored in **Firebase**.
   - Redirects to the **Leaderboard Page**.
5. **Leaderboard Page:**
   - Displays top scores from Firebase.
   - Allows competitive tracking.

## 🏗️ Tech Stack

- **Flutter (Dart)**: Core framework for app development.
- **Firebase (Firestore & Authentication)**: Manages user scores and leaderboard.
- **Confetti Animation**: Celebration effect on winning.
- **Leanback Library**: Optimizes UI for **Android TV**.

## 🎨 UI Design

- **Multi-Touch Interaction:** Enables smooth gameplay.
- **Portrait Mode (3840 x 2160):** Optimized for large screens.
- **TV-Friendly Navigation:** Supports **touch & remote input**.
- **Dynamic Timer Bar:** Turns **red** when time is low.

## 🛠️ Setup & Installation

### 1. Clone the Repository

```sh
$ git clone https://github.com/yourusername/grab-hot-deal-game.git
$ cd grab-hot-deal-game
```

### 2. Install Dependencies

```sh
$ flutter pub get
```

### 3. Run the App

#### For Android TV (TR3DK Series)

```sh
$ flutter build apk --release
$ adb install build/app/outputs/flutter-apk/app-release.apk
```

### 4. Configure Firebase

- Set up **Firebase project**.
- Enable **Firestore Database & Authentication**.
- Download `google-services.json` and place it in `android/app/`.

## 📂 File Structure

```
lib/
 ├── main.dart               # Entry point
 ├── pages/
 │   ├── start_page.dart      # Start screen
 │   ├── tutorial_page.dart   # Instructions & rules
 │   ├── game_page.dart       # Game logic & timer
 │   ├── win_screen.dart      # Name submission form
 │   ├── leaderboard.dart     # Top player rankings
 ├── services/
 │   ├── firebase_service.dart # Handles Firebase operations
 ├── widgets/
 │   ├── promo_card.dart      # UI component for promo selections
```

## 🖥️ Android TV & Multi-Touch Support

- **Manifest Updates**: `LEANBACK_LAUNCHER` intent ensures **TV compatibility**.
- **Gradle Configuration**:
  - `minSdkVersion 21`
  - `targetSdkVersion 33`
  - `androidx.leanback:leanback:1.1.0`
  - `androidx.multidex:multidex:2.0.1`

## 🎉 Win Screen Celebration

- **Confetti Animation** on successful win.
- **Firebase Upload** for leaderboard tracking.

## 📜 License

This project is licensed under the MIT License.

## 🤝 Contributing

1. Fork the repo.
2. Create a new branch (`git checkout -b feature-name`).
3. Commit your changes (`git commit -m 'Add new feature'`).
4. Push to the branch (`git push origin feature-name`).
5. Submit a Pull Request.

## 📬 Contact

For any questions or suggestions, feel free to reach out:

- 📧 Email: [your.email@example.com](mailto\:your.email@example.com)
- 💬 Instagram: [@tonythetechie](https://instagram.com/tonythetechie)



