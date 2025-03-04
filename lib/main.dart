import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grabpromogame/Start_page.dart';

import 'package:grabpromogame/firebase_options.dart';
import 'package:grabpromogame/game_page.dart';
import 'package:grabpromogame/leaderboard.dart';
import 'package:grabpromogame/losingScreen.dart';
import 'package:grabpromogame/namesubmission.dart';
import 'package:grabpromogame/util.dart';

import 'package:grabpromogame/winningScreen.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await windowManager.ensureInitialized();
  await WindowManager.instance.waitUntilReadyToShow().then((_) async {
    await windowManager.setFullScreen(true);
    await windowManager.show();
    await windowManager.focus();
  });
  initializeAudioPlayers();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

//Grab Promo APP for TV
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Grab Hot-Deals',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromRGBO(0, 177, 79, 1)),
          primaryColor: const Color.fromRGBO(0, 177, 79, 1),
          useMaterial3: true,
          fontFamily: 'GrabCommunitySolidTH',
        ),
        home: PromoSelectionGame()
        //NameSubmissionScreen(score: 7)

        // LeaderboardScreen(
        //     highScore: 6, playerSessionID: "Nont2025-03-01 18:01:19.412"),
        );

    // StartScreen());
  }
}
