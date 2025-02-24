import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grabpromogame/firebase_options.dart';
import 'package:grabpromogame/game_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      home: const PromoSelectionGame(),
    );
  }
}
