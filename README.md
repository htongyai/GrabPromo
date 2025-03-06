# GrabPromo - Grab Hot Deal Game

## Overview
GrabPromo is an interactive promotional selection game developed for Android TV (TR3DK Series) devices with multi-touch support. Players are challenged to select at least five restaurant promotions offering an 80% discount before the timer expires. The game features real-time leaderboards, allowing participants to compete for high scores.

## Features

- **Android TV Optimization:** Designed specifically for TR3DK Series devices running at 3840 x 2160 resolution in portrait mode.
- **Multi-Touch Support:** Enables efficient and responsive player interactions.
- **Firebase Integration:** Stores player names and scores, facilitating real-time leaderboard updates.
- **Structured Game Flow:** Guides players from the start screen through tutorials, gameplay, and leaderboards.
- **Challenging Gameplay:** Players must quickly identify correct promotions under time constraints, enhancing engagement.

## Screens & Flow

1. **Start Page:**
   - Displays the game title with an option to begin.
2. **Tutorial Page:**
   - Provides game rules: Select at least five promotions with an 80% discount before time runs out.
3. **Game Page:**
   - Interactive selection of promo offers.
   - **Countdown Timer:** Penalizes incorrect selections by reducing available time.
   - **Win Condition:** Select five correct promotions before 50% of the time elapses.
   - **Lose Condition:** Failure to meet the win condition within the allotted time.
4. **Leaderboard Page:**
   - Displays top player rankings based on scores stored in Firebase.

## Installation & Setup

To deploy GrabPromo on a compatible Android TV device:

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/htongyai/GrabPromo.git
   ```
2. **Navigate to the Project Directory:**
   ```bash
   cd GrabPromo
   ```
3. **Open the Project in Android Studio:**
   - Ensure you have the latest version of [Android Studio](https://developer.android.com/studio) installed.
4. **Connect the Android TV Device:**
   - Enable developer options and USB debugging on the device.
   - Connect the device to your development machine via USB or ensure both are on the same network for wireless debugging.
5. **Build and Run the Application:**
   - In Android Studio, select the appropriate build variant.
   - Click 'Run' to deploy the application to the connected device.

## Event Performance Summary

During the Grab Hot Deals Event on March 5, 2025, the software was deployed successfully with the following outcomes:

- **Total Successful Players:** 340 (achieved 4 or more points)
- **Total Failed Attempts:** Over 400 (specific data not collected)
- **Identified Issues:**
  - Screen power settings and screensaver interruptions.
  - Minor UI bugs in leaderboard rankings (e.g., gold No. 1 color inconsistencies and millisecond display errors).
  - Insufficient on-site staff training for troubleshooting and maintenance.

## Known Issues & Recommendations

- **Screen Settings:** Disable screensaver and power-saving modes before deployment to prevent interruptions.
- **Staff Training:** Provide comprehensive training to on-site staff on basic troubleshooting, including restarting the software and managing display settings.
- **UI Enhancements:** Address leaderboard color inconsistencies and timing display errors in future updates.
- **Screen Maintenance:** Implement regular screen cleaning protocols (e.g., every 30 minutes) to maintain optimal visibility and responsiveness.

## Future Enhancements

- **Enhanced Leaderboard UI:** Improve visual consistency and accuracy.
- **Auto-Restart Functionality:** Implement automatic recovery mechanisms to handle potential software crashes or freezes.
- **Comprehensive Data Collection:** Capture detailed metrics on both successful and failed attempts for better analysis.
- **Detailed Staff Documentation:** Provide on-site staff with thorough troubleshooting guides and maintenance procedures.

## Contributing

Contributions are welcome! To propose enhancements or report bugs:

1. **Fork the Repository:** Click the 'Fork' button at the top right corner of the repository page.
2. **Create a New Branch:** Use a descriptive name for your branch (e.g., `feature-enhancement`).
3. **Commit Your Changes:** Provide clear and concise commit messages.
4. **Submit a Pull Request:** Ensure your pull request describes the changes made and references any relevant issues.

## License

This project is licensed under the [MIT License](LICENSE).

## Contact

For inquiries or support, please contact [Your Name] at [your.email@example.com].
